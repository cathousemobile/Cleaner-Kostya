//
//  SFGalleryFinder.swift
//


import Photos
import UIKit
import CocoaImageHashing

// TODO: Вычисление размеров фото

/// Сервис по работе с галереей, занимается поиском дубликатов, предоставлением данных.
/// Если в галерее на устройстве произошли изменения, то сервис перезапускает поиск, а по завершению отправляет   `SFNotificationSystem.galleryFinderUpdated`
/// - Important: Для работы требуется:
/// * Зависимость [CocoaImageHashing](https://github.com/ameingast/cocoaimagehashing)
/// * Указать `Privacy - Photo Library Usage Description` в `Info` таргета
class SFGalleryFinder: NSObject {
    
    // MARK: - Singletone
    
    static let shared = SFGalleryFinder()
    private override init() { super.init() }
    
    // MARK: - Open Proporties
    
    /// Находится ли сервис в состоянии поиска дубликатов
    public var inProcess: Bool = false
    
    /// Сервис отработал хотя бы 1 раз
    public var workedOneTime: Bool = false
    
    // MARK: - Private Proporties
    

    private var photos = [PHAsset]()
    private var videos = [PHAsset]()
    private var screenshots = [PHAsset]()
    private var photoDuplicates = [[PHAsset]]()
    private var videoDuplicates = [[PHAsset]]()
    private let galleryManager = PHCachingImageManager()
    private var photosFetchResult: PHFetchResult<PHAsset>? = nil
    private var videosFetchResult: PHFetchResult<PHAsset>? = nil
    private var operationQueue = OperationQueue()
    
    func start() {
        guard checkAccess() else { return }
        requestDataAndFindMedia()
        setupObserers()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    /// Проверка, дал ли юзер доступ к галерее
    /// - Important: в IOS 14 есть фунция выборочного доступа к фото, читайте `Returns` метода, что бы понять как это рабоотает. Для проверки что доступ именно ограниченный - используйте метод `isLimittedAccess`.
    /// - Returns: `true` - пользователь выдал ограниченный или полный доступ; `false` - доступ не запрашивался или было отказано в доступе
    func checkAccess() -> Bool {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            return status == .limited || status == .authorized
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            return status == .authorized
        }
    }
    
    /// Проверка, что пользователь предоставил доступ к ограниченному количеству фотографий.
    /// Так как фишка пришла с iOS 14, то в версиях до нее будет возвращаться false
    func isLimittedAccess() -> Bool {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            return status == .limited
        } else {
            return false
        }
    }
    
    /// Запрос доступа к контактам пользователя
    /// - Returns: результат запроса
    func requestAccess(fullAccessGranted: @escaping SFVoidCallback, limitedAccessGranted: @escaping SFVoidCallback, needShowDeniedAlert: @escaping SFVoidCallback) {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
            switch status {
            case .notDetermined, .restricted:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized:
                        fullAccessGranted()
                        self.start()
                    case .limited:
                        limitedAccessGranted()
                        self.start()
                    default:
                        needShowDeniedAlert()
                    }
                }
            case .authorized:
                fullAccessGranted()
            case .limited:
                limitedAccessGranted()
            default:
                needShowDeniedAlert()
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case .notDetermined, .restricted:
                PHPhotoLibrary.requestAuthorization() { status in
                    switch status {
                    case .authorized:
                        fullAccessGranted()
                        self.requestDataAndFindMedia()
                    case .limited:
                        limitedAccessGranted()
                        self.requestDataAndFindMedia()
                    default:
                        needShowDeniedAlert()
                    }
                }
            case .authorized:
                fullAccessGranted()
            case .limited:
                limitedAccessGranted()
            default:
                needShowDeniedAlert()
            }
        }
    }
    
    /// Получить весь контент из галереи
    func getAll() throws -> [PHAsset]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        return photos + screenshots + videos
    }
    
    /// Получить все фотографии из галереи
    func getAllProtos() throws -> [PHAsset]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        return photos + screenshots
    }
    
    /// Получить все видеозаписи из галереи
    func getAllVideos() throws -> [PHAsset]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        return videos
    }
    
    /// Получить скриншоты из галереи
    func getScreenshots() throws -> [PHAsset]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        return screenshots
    }
    
    /// Получить дубликаты фото
    /// - Returns: Дубликаты собраны в группы 
    func getPhotoDuplicates() throws -> [[PHAsset]]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        return photoDuplicates
    }
    
    /// Получить дубликаты видео
    /// - Returns: Дубликаты собраны в группы
    func getVideoDuplicates() throws -> [[PHAsset]]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        return videoDuplicates
    }
    
    /// Получить размер занимаемой памяти для объктов галереи опеределенного типа
    func getSizeOf(_ type: SFGalleryFinderType) -> Int64 {
        let data: [PHAsset]
       
        switch type {
        case .allGallery:
            data = photos + screenshots + videos
        case .allPhotos:
            data = photos
        case .allVideos:
            data = videos
        case .allScreenshots:
            data = screenshots
        case .photoDuplicates:
            data = photoDuplicates.flatMap({ $0 })
        case .videoDuplicates:
            data = videoDuplicates.flatMap({ $0 })
        }
        
        return data.reduce(0, { $0 + $1.assetSize })
    }
    
    
    /// Удалить ассеты из галереи (учтите что покажется системный алерт, с миниатюрами удаляемых элементов)
    /// - Parameters:
    ///   - assets: ассеты, которые нужно удалить
    ///   - completion: колбэк завершения, может вернуть ошибку
    func deleteAssets(_ assets: [PHAsset], completion: ((Error?) -> Void)? = nil) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(NSArray(array: assets))
        }) { success, error in
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }
    
    /// Удалить ассеты из галереи определенного типа (учтите что покажется системный алерт, с миниатюрами удаляемых элементов)
    /// - Parameters:
    ///   - types: типы контента, которые нужно удалить (`.allGallery` - весь контент галереии; `.allPhotos` - все фото, за исключением скриншотов; `.allVideos` - все видео; `.photoDuplicates` - удалит дубликаты, но оставит лучший снимок; `.videoDuplicates` - удалит дубликаты, но оставит лучшее видео)
    ///   - completion: колбэк завершения, может вернуть ошибку
    func smartDeleting(types:  Set<SFGalleryFinderType>, completion: ((Error?) -> Void)? = nil) {
        var dataToDelete: [PHAsset] = []
        
        types.forEach { type in
            switch type {
            case .allGallery:
                dataToDelete.append(contentsOf: photos + screenshots + videos)
            case .allPhotos:
                dataToDelete.append(contentsOf: photos)
            case .allVideos:
                dataToDelete.append(contentsOf: videos)
            case .allScreenshots:
                dataToDelete.append(contentsOf: screenshots)
            case .photoDuplicates:
                let content = photoDuplicates.flatMap {
                    var sortedByScore = $0.sorted(by: { $0.score > $1.score })
                    sortedByScore.removeFirst()
                    return sortedByScore
                }
                dataToDelete.append(contentsOf: content)
            case .videoDuplicates:
                let content = videoDuplicates.flatMap {
                    var sortedByScore = $0.sorted(by: { $0.score > $1.score })
                    sortedByScore.removeFirst()
                    return sortedByScore
                }
                dataToDelete.append(contentsOf: content)
            }
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(NSArray(array: dataToDelete))
        }) { success, error in
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }
    
    /// Загрузка картинки для любого ассета (в том числе видео)
    /// - Parameters:
    ///   - asset: ассет, для которого загружаем картинку
    ///   - allowMaximumSize: грузить ли в максимальном размере? по умолчанию грузит в соответсвии с размером экрана (хорошо, если отображаете картинку в коллекции). Если грузите картинку для просмотра, с возможностью зума и тд, то устанавливайте это свойство в true
    ///   - completionHandler: Результат загрузки. Может вернуться nil, если загрузить картинку не получилось
    func fetchImage(for asset: PHAsset, allowMaximumSize: Bool = false, completionHandler: @escaping (UIImage?) -> Void) {
        let size = allowMaximumSize ? PHImageManagerMaximumSize : CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: UIScreen.main.bounds.width * UIScreen.main.scale)
        galleryManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler: { image, error in
            completionHandler(image)
            if let error = error {
                print("Error with fetching image", error)
            }
        })
    }
    
    /// Загрузка URL адреса ассета (дальше он передается в AVPlayer)
    /// - Parameters:
    ///   - asset: ассет, для которого загружаем картинку
    ///   - completionHandler: Результат загрузки. Может вернуться nil, если не удалось получить ассет или ассет не видео
    func fetchVideoURLAsset(for asset: PHAsset, completionHandler: @escaping (AVURLAsset?) -> Void) {
        guard asset.mediaType == .video else {
            completionHandler(nil)
            print("Media type don't equal .video")
            return
        }
        
        galleryManager.requestAVAsset(forVideo: asset, options: nil) { videoAsset, _, _ in
            if let videoAsset = videoAsset as? AVURLAsset {
                completionHandler(videoAsset)
            } else {
                completionHandler(nil)
                print("Failed to recive AVURLAsset")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupObserers() {
        PHPhotoLibrary.shared().register(self)
    }
    
    private func requestDataAndFindMedia() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            let fetchOptions = PHFetchOptions()
            let sortOrder = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.sortDescriptors = sortOrder
            fetchOptions.includeHiddenAssets = true
            
            self.photosFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            self.videosFetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
            self.findMedia()
        }
    }
    
    private func checkErrorsForOperations() -> SFGalleryFinderError? {
        if checkAccess() == false { return .noAccess }
        if inProcess == true { return .serviceInProcess }
        if workedOneTime == false { return .serviceNeverLaunched }
        return nil
    }
    
    private func findMedia() {
        operationQueue.cancelAllOperations()
        operationQueue.maxConcurrentOperationCount = 1
        
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }
            guard self.checkAccess() == true else { return }
            
            print("findMedia start, operationCount:", self.operationQueue.operationCount)
            
            self.inProcess = true
            self.galleryManager.stopCachingImagesForAllAssets()
            self.screenshots.removeAll()
            self.photos.removeAll()
            self.screenshots.removeAll()
            self.videos.removeAll()
            
            // Достаем все фото, фильтруем на скрины и все остальное
            if let phFetchResult = self.photosFetchResult {
                phFetchResult.enumerateObjects { (accet, count, stop) in
                    if accet.mediaSubtypes == .photoScreenshot {
                        self.screenshots.append(accet)
                    } else {
                        self.photos.append(accet)
                    }
                }
                self.findSimilarPhotos()
            }
            
            let size = CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: UIScreen.main.bounds.width * UIScreen.main.scale)
            self.galleryManager.startCachingImages(for: self.screenshots + self.photos + self.videos, targetSize: size, contentMode: .aspectFit, options: nil)
            
            // Достаем все видео
            if let videosFetchResult = self.videosFetchResult {
                videosFetchResult.enumerateObjects { (accet, count, stop) in
                    self.videos.append(accet)
                }
                self.findSimilarVideos()
            }
            
            self.workedOneTime = true
            
            if self.operationQueue.operationCount < 2 {
                self.inProcess = false
                SFNotificationSystem.send(event: .galleryFinderUpdated)
            }
        }
        
        operationQueue.addOperations([operation], waitUntilFinished: false)
    }
    
    private func findSimilarPhotos() {
        var images: [OSTuple<NSString, NSData>] = []
        photos.enumerated().forEach {
            guard let data = $1.image?.jpegData(compressionQuality: 0.8) else {
                return
            }
            let tuple = OSTuple<NSString, NSData>(first: "\($0)" as NSString,
                                                  andSecond: data as NSData)
            
            images.append(tuple)
        }
        
        let similarImageIds = OSImageHashing.sharedInstance().similarImages(with: .low, forImages: images)
        
        
        var indexes: [Int: [Int]] = [:]
        similarImageIds.forEach {
            guard let firstIndex = $0.first?.integerValue,
                  let secondIndex = $0.second?.integerValue else {
                return
            }
            
            if indexes.contains(where: { $0.value.contains(secondIndex) || $0.value.contains(firstIndex) }) {
                return
            }
            
            if let array = indexes[firstIndex] {
                indexes[firstIndex] = array + [secondIndex]
            } else if let array = indexes[secondIndex] {
                indexes[secondIndex] = array + [firstIndex]
            } else {
                indexes[firstIndex] = [secondIndex]
            }
        }
        
        let positions = indexes
            .sorted(by: { $0.key < $1.key })
            .map { [$0.key] + $0.value }
        photoDuplicates.removeAll()
        positions.forEach {
            let data = $0.compactMap { photos[safe: $0] }.removedDuplicates()
            guard data.isEmpty == false else { return }
            photoDuplicates.append(data)
        }
    }
    
    private func findSimilarVideos() {
        var images: [OSTuple<NSString, NSData>] = []
        videos.enumerated().forEach {
            guard let data = $1.image?.jpegData(compressionQuality: 0.8) else {
                return
            }
            let tuple = OSTuple<NSString, NSData>(first: "\($0)" as NSString,
                                                  andSecond: data as NSData)
            
            images.append(tuple)
        }
        
        let similarVideosIds = OSImageHashing.sharedInstance().similarImages(with: .low, forImages: images)
        
        
        var indexes: [Int: [Int]] = [:]
        similarVideosIds.forEach {
            guard let firstIndex = $0.first?.integerValue,
                  let secondIndex = $0.second?.integerValue else {
                return
            }
            
            if indexes.contains(where: { $0.value.contains(secondIndex) || $0.value.contains(firstIndex) }) {
                return
            }
            
            if let array = indexes[firstIndex] {
                indexes[firstIndex] = array + [secondIndex]
            } else if let array = indexes[secondIndex] {
                indexes[secondIndex] = array + [firstIndex]
            } else {
                indexes[firstIndex] = [secondIndex]
            }
        }
        let positions = indexes
            .sorted(by: { $0.key < $1.key })
            .map { [$0.key] + $0.value }
        
        videoDuplicates.removeAll()
        positions.forEach {
            let data = $0.compactMap { videos[safe: $0] }.removedDuplicates()
            guard data.isEmpty == false else { return }
            videoDuplicates.append(data)
        }
    }
    
}

// MARK: - PHAsset Extension
fileprivate extension PHAsset {
    
    /// To get Thumbnail image from PHAssets
    var image: UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail: UIImage?
        option.isSynchronous = true
        manager.requestImage(for: self, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result
        })
        return thumbnail
    }

    /// To get size image on disk from PHAssets
    var assetSize : Int64 {
        let resources = PHAssetResource.assetResources(for: self)
        var sizeOnDisk: Int64 = 0
        
        if let resource = resources.first {
            let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
            sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
        }
        
        return sizeOnDisk
    }
}


//MARK: - PHPhotoLibraryChangeObserver
extension SFGalleryFinder: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        if let photos = photosFetchResult, let changes = changeInstance.changeDetails(for: photos) {
            self.photosFetchResult = changes.fetchResultAfterChanges
            findMedia()
        } else if let videos = videosFetchResult, let changes = changeInstance.changeDetails(for: videos) {
            self.videosFetchResult = changes.fetchResultAfterChanges
            findMedia()
        }
    }
}
