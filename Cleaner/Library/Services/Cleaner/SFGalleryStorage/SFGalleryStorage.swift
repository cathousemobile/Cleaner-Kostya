//
//  SFGalleryStorage.swift
//


import Foundation
import Photos
import UIKit
import PhotosUI
import QuickLook

/// Секретное хранилище для элементов галереи на устройстве пользователя. Удаление элемента из галереи на устройстве, не повлияет на элементы в секретном хранилище
/// Если элементы в секретном хранилище были изменены, то отправистя нотификация  `SFNotificationSystem.galleryStorageUpdated`
class SFGalleryStorage: NSObject {
    
    // MARK: - Singletone
    
    static let shared = SFGalleryStorage()
    private override init() { super.init() }
    
    // MARK: - Public Properties
    
    typealias AssetCallback = (_ vc: UIViewController, _ assets: [SFGalleryStorageAsset]) -> Void
    
    // MARK: - Private Properties
    
    private var assets: [SFGalleryStorageAsset] {
        set {
            do {
                try UserDefaults.standard.set(object: newValue, forKey: "secretGallery")
            } catch (let error) {
                print("Fail with saving assets", error.localizedDescription)
            }
            
        } get {
            do {
                let data = try UserDefaults.standard.get(objectType: [SFGalleryStorageAsset].self, forKey: "secretGallery")
                return data ?? []
            } catch (let error) {
                print("Fail with reading assets", error.localizedDescription)
            }
            return []
        }
    }
    
    private var assetPickerVCCallbacks: [UIViewController: AssetCallback] = [:]
    
    // MARK: - Public Methods
    
    /// Получить ассеты из секретной папки
    /// - Returns: Ассеты
    func getAll() -> [SFGalleryStorageAsset] {
        assets
    }
    
    /// Сохранить ассет в секретном хранилище
    /// - Parameter newAsset: ассет, который нужно сохранить
    func save(_ newAsset: SFGalleryStorageAsset) {
        
        var existingAssets = assets
        existingAssets.append(newAsset)
        assets = existingAssets
        
        SFNotificationSystem.send(event: .galleryStorageUpdated)
    }
    
    /// Сохранить ассеты в секретном хранилище
    /// - Parameter newAssets: ассеты, которые нужно сохранить
    func save(_ newAssets: [SFGalleryStorageAsset]) {
        var existingAssets = assets
        existingAssets.append(contentsOf: newAssets)
        assets = existingAssets
        
        SFNotificationSystem.send(event: .galleryStorageUpdated)
    }
    
    /// Удалить ассет из секретного  хранилища
    /// - Parameter assetForDeliting: ассет, который нужно удалить
    /// - Returns: Результат удаления. `false` - если не удалось найти ассет в хранилище; `true` - удаление прошло успешно
    func delete(_ assetForDeliting: SFGalleryStorageAsset) -> Bool {
        var existingAssets = assets
        let assetsToDelete = existingAssets.filter({ $0 == assetForDeliting })
        existingAssets.removeAll(where: { $0 == assetForDeliting })
        assets = existingAssets
        
        SFNotificationSystem.send(event: .galleryStorageUpdated)
        return assetsToDelete.isEmpty == false
    }
    
    /// Удалить ассеты из секретного  хранилища
    /// - Parameter assetsForDeliting: ассеты, которые нужно удалить
    /// - Returns: Результат удаления. `false` - если не удалось найти 1 или больше ассетов в хранилище (при этом часть ассетов могла успешно удалиться); `true` - удаление прошло успешно
    func delete(_ assetsForDeliting: [SFGalleryStorageAsset]) -> Bool {
        var existingAssets = assets
        let contactsToDelete = existingAssets.filter({ assetsForDeliting.contains($0) })
        existingAssets.removeAll(where: { assetsForDeliting.contains($0) })
        assets = existingAssets
        
        SFNotificationSystem.send(event: .galleryStorageUpdated)
        return contactsToDelete.count >= assetsForDeliting.count
    }
    
    
    /// Получить нативный для выбора данных из галереи (пока что можно выбирать только 1 элемент)
    /// - Parameters:
    ///   - allowMultiplySelection: Разрешен ли выбор нескольких элементов из галереи (работает только для iOS 14+)
    ///   - didCompleteCallback: Колбэк завершения, в нем нужно закрыть контроллер (сам не закрывается). Если фото было выбрано, то вернется PHAsset
    ///- Important: Метод не сохраняет ассет в системе, а только передает вам выбор пользователя. Для сохранения используйте `save()`
    func chooseFromGalleryController(allowMultiplySelection: Bool, didCompleteCallback callback: @escaping AssetCallback) -> UIViewController {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = allowMultiplySelection ? 0 : 1
            let cvc = PHPickerViewController(configuration: configuration)
            cvc.delegate = self
            cvc.isEditing = false
            assetPickerVCCallbacks[cvc] = callback

            return cvc
        } else {
            let cvc = UIImagePickerController()
            cvc.allowsEditing = false
            cvc.delegate = self
            cvc.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
            assetPickerVCCallbacks[cvc] = callback
            
            return cvc
        }
    }
    
    private func secureCopyItem(at srcURL: URL) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first!
        let fileNmae = srcURL.lastPathComponent
        let secretDirectory = documentsDirectory.appendingPathComponent("secretGalley")
        let newFilePath = secretDirectory.appendingPathComponent(fileNmae)
        print(newFilePath.path)
        do {
            
            // проверяем наличие папки
            if FileManager.default.fileExists(atPath: secretDirectory.path) == false {
                try FileManager.default.createDirectory(atPath: secretDirectory.path, withIntermediateDirectories: false, attributes: nil)
            }
            
            // проверяем что такого файла нет
            if FileManager.default.fileExists(atPath: newFilePath.path) {
                try FileManager.default.removeItem(at: newFilePath)
            }
            
            // копируем
            try FileManager.default.copyItem(at: srcURL, to: newFilePath)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(newFilePath): \(error)")
            return nil
        }
        return newFilePath
    }
    
    private func getThumbnail(forUR url: URL, completion: @escaping (UIImage?) -> Void) {
        let previewGenerator = QLThumbnailGenerator()
        let thumbnailSize = CGSize(width: 300, height: 300)
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(fileAt: url, size: thumbnailSize, scale: scale, representationTypes: .thumbnail)
        previewGenerator.generateBestRepresentation(for: request) { (thumbnail, error) in
            if let error = error {
                print("Error with generating Thumbnail:", error.localizedDescription)
                completion(nil)
            } else if let thumb = thumbnail {
                completion(thumb.uiImage)
            }
        }
    }
}


// MARK: - UIImagePickerControllerDelegate

extension SFGalleryStorage: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let assetURL = info[.mediaURL] as? URL, let newUrl = self.secureCopyItem(at: assetURL) else {
            assetPickerVCCallbacks[picker]?(picker, [])
            return
        }
        
        let isVideo: Bool = {
            let type = info[.mediaType] as? String
            return type?.contains("movie") == true ? true : false
        }()
        
        self.getThumbnail(forUR: newUrl) { image in
            let imageData: Data? = {
                guard let image = image else {
                    return nil
                }
                return image.pngData()
            }()

            let asset = SFGalleryStorageAsset(url: newUrl, type: isVideo ? .video : .photo, thumbnailData: imageData)
         
            DispatchQueue.main.async {
                self.assetPickerVCCallbacks[picker]?(picker, [asset])
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        assetPickerVCCallbacks[picker]?(picker, [])
    }
}

@available(iOS 14.0, *)
extension SFGalleryStorage: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var assets = [SFGalleryStorageAsset]()
        let queue = OperationQueue()
        queue.qualityOfService = .default
        results.forEach { result in
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                queue.addOperation {
                    let semaphore = DispatchSemaphore(value: 0)
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                        if let url = url, let newUrl = self.secureCopyItem(at: url) {
                            self.getThumbnail(forUR: newUrl) { image in
                                let imageData: Data? = {
                                    guard let image = image else {
                                        return nil
                                    }
                                    return image.pngData()
                                }()
                                
                                let asset = SFGalleryStorageAsset(url: newUrl, type: .video, thumbnailData: imageData)
                                assets.append(asset)
                                semaphore.signal()
                            }
                        } else {
                            semaphore.signal()
                        }
                    }
                    semaphore.wait()
                }
            } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                queue.addOperation {
                    let semaphore = DispatchSemaphore(value: 0)
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                        if let url = url, let newUrl = self.secureCopyItem(at: url) {
                            self.getThumbnail(forUR: newUrl) { image in
                                let imageData: Data? = {
                                    guard let image = image else {
                                        return nil
                                    }
                                    return image.pngData()
                                }()
                                
                                let asset = SFGalleryStorageAsset(url: newUrl, type: .photo, thumbnailData: imageData)
                                assets.append(asset)
                                semaphore.signal()
                            }
                        } else {
                            semaphore.signal()
                        }
                    }
                    semaphore.wait()
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        DispatchQueue.main.async {
            self.assetPickerVCCallbacks[picker]?(picker, assets)
        }
    }
}
