//
//  ContactCleanerViewController.swift
//

import UIKit
import ContactsUI
import SPAlert

final class ContactCleanerViewController: UIViewController {
    
    enum ContactsArrayType {
        case allContacts
        case allDuplicates
        case mergeNames
        case mergePhones
        case noName
        case noPhones
    }
    
    enum TableCellType {
        case simple
        case merge
    }
    
    // MARK: - UI Elements
    
    private let contentView = ContactCleanerView()
    
    private lazy var searchController = UISearchController()
    
    private let clearAllButton = UIBarButtonItem()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private let dispatchGroup = DispatchGroup()
    
    private var isSearching = false
    private var wasCheked = false
    
    private var dataArrayType: ContactsArrayType? {
        didSet {
            if oldValue != dataArrayType {
                fetchMedia()
            }
        }
    }
    
    private var tableCellType: TableCellType = .simple {
        didSet {
            guard oldValue != tableCellType else {return}
            contentView.tableView.separatorStyle = tableCellType == .merge ? .none : .singleLine
        }
    }
    
    private var simpleDataSource: SimpleContactsTableViewDiffibleDataSource!
    private var mergeDataSource: MergeContactsTableViewDiffibleDataSource!
    
    private var simpleContactsArray = [[SFContact]]()
    
    private var currentMergeContactsDictionary = [SFContact : [SFContact]]()
    
    private var simpleContactSearchArray = [[SFContact]]() {
        didSet {
            if oldValue != simpleContactSearchArray { initDataAndSnap() }
        }
    }
    
    private var mergeContactsSearchDictionary = [SFContact : [SFContact]]() {
        didSet {
            if oldValue != mergeContactsSearchDictionary { initDataAndSnap() }
        }
    }
    
    // MARK: - Life cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Generated.Text.Main.contactsCleaner
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !wasCheked {
            checkAccess()
        }
    }
    
}

// MARK: - Init

extension ContactCleanerViewController {
    
    func checkAccess() {
        
        SFContactFinder.shared.requestAccess { [weak self] in
            guard let self = self else { return }
            self.dataArrayType = .allContacts
            self.wasCheked = true
        } needShowDeniedAlert: { [weak self] in
            guard let self = self else { return }
            self.wasCheked = false
            DispatchQueue.main.async {
                AppCoordiator.shared.routeToSettings(Generated.Text.ContactCleaner.permissionRequared, currentVC: self)
            }
        }

    }
    
    func initData() {
        configureSearchController()
        configureTableView()
        setupActions()
        initNotifications()
    }
    
}

// MARK: - NavigationBar Config

extension ContactCleanerViewController {
    
    func configureRightButton(_ isEmpty: Bool) {
        
        if !isEmpty {
            clearAllButton.title = tableCellType == .merge ? Generated.Text.ContactCleaner.mergeAll : Generated.Text.ContactCleaner.cleanAll
            clearAllButton.style = .plain
            clearAllButton.target = self
            clearAllButton.action = #selector(clearAllAction)
            clearAllButton.tintColor = Generated.Color.redWarning
            
            self.navigationItem.rightBarButtonItem = clearAllButton
            
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
}

// MARK: - UISearchBar Config

extension ContactCleanerViewController: UISearchBarDelegate {
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = Generated.Text.Common.search
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)  {
        filterItems(text: searchController.searchBar.text)
    }
    
    func filterItems(text: String?) {
        
        guard let text = text, !text.isEmpty else {
            isSearching = false
            initSnapshot()
            return
        }
        
        isSearching = true
        
        switch tableCellType {
        case .simple:
            
            simpleContactSearchArray.removeAll()
            
            let filteredContatsArray = simpleContactsArray.reduce([], +).filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
            filteredContatsArray.isEmpty ? simpleContactSearchArray = [] : simpleContactSearchArray.append(filteredContatsArray)
            
        case .merge:
            mergeContactsSearchDictionary = currentMergeContactsDictionary.filter({ $0.key.name?.lowercased().contains(text.lowercased()) ?? false })
        }
        
    }
    
}

// MARK: - TableView Config

private extension ContactCleanerViewController {
    
    func configureTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.register(ContactCleanerTableSimpleCell.self, forCellReuseIdentifier: "cellDuplicate")
        contentView.tableView.register(ContactCleanerTableMergeCell.self, forCellReuseIdentifier: "cellMerge")
    }
    
}

// MARK: - TableView Delegate

extension ContactCleanerViewController: UITableViewDelegate {
    
}

// MARK: - TableView Datasource

extension ContactCleanerViewController {
    
    func initDataAndSnap() {
        
        dispatchGroup.notify(queue: .main) {
            self.contentView.hideSpinner(true)
            self.initDataSource()
            self.initSnapshot()
        }
        
    }
    
    func initDataSource() {
        
        switch tableCellType {
            
        case .simple:
            
            self.simpleDataSource = SimpleContactsTableViewDiffibleDataSource(tableView: self.contentView.tableView, cellProvider: { [weak self] tableView, indexPath, contactModel in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellDuplicate", for: indexPath) as! ContactCleanerTableSimpleCell
                
                cell.setContactName(contactModel.name)
                cell.setContactNumber(contactModel.numbers.first)
                
                cell.setAction {
                    guard let self = self else { return }
                    self.simpleCellAction(contactModel)
                }
                
                return cell
                
            })
            
        case .merge:
            
            self.mergeDataSource = MergeContactsTableViewDiffibleDataSource(tableView: self.contentView.tableView, cellProvider: { [weak self] tableView, indexPath, contactsArray in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellMerge", for: indexPath) as! ContactCleanerTableMergeCell
                cell.setContactName(contactsArray.first?.name)
                cell.addContactsToMergeList(contactsArray.filter({ $0 != contactsArray.first }))
                
                cell.setAction {
                    guard let self = self else { return }
                    self.mergeCellAction(contactsArray)
                }
                
                return cell
            })
            
        }
        
    }
    
    func initSnapshot() {
        
        switch tableCellType {
            
        case .simple:
            
            var snapshot = NSDiffableDataSourceSnapshot<String, SFContact>()
            
            var dataArray = [SFContact]()
            
            if isSearching {
                dataArray = simpleContactSearchArray.reduce([], +)
            } else {
                dataArray = simpleContactsArray.reduce([], +)
            }
            
            let dataDictionary = Dictionary(grouping: dataArray) { $0.name?.uppercased().first?.description ?? " " }
            
            let sections = dataDictionary.keys.compactMap( {$0} ).sorted(by: { $0 < $1 })
            
            snapshot.appendSections(sections)
            
            sections.forEach { section in
                if let items = dataDictionary[section] {
                    snapshot.appendItems(items, toSection: section)
                }
            }
            
            simpleDataSource.apply(snapshot, animatingDifferences: true)
            
            self.checkData(snapshot.itemIdentifiers.isEmpty)
            
        case .merge:
            
            var snapshot = NSDiffableDataSourceSnapshot<String, [SFContact]>()
            
            var dataArray = [[SFContact]]()
            
            if isSearching {
                for (key, value) in mergeContactsSearchDictionary {
                    var resultArray = value
                    resultArray.insert(key, at: 0)
                    dataArray.append(resultArray)
                }
                
            } else {
                for (key, value) in currentMergeContactsDictionary {
                    var resultArray = value
                    resultArray.insert(key, at: 0)
                    dataArray.append(resultArray)
                }
                
            }
            
            snapshot.appendSections(["main"])
            snapshot.appendItems(dataArray, toSection: "main")
            
            mergeDataSource.apply(snapshot, animatingDifferences: true)
            
            self.checkData(snapshot.itemIdentifiers.isEmpty)
            
        }
        
    }
    
}

// MARK: - Handlers

private extension ContactCleanerViewController {
    
    func routeHelp() {
        
        if let simpleDataSource = self.simpleDataSource, simpleDataSource.snapshot().numberOfItems != 0 {
            var snap = simpleDataSource.snapshot()
            snap.deleteAllItems()
            simpleDataSource.apply(snap)
        }
        if let mergeDataSource = self.mergeDataSource, mergeDataSource.snapshot().numberOfItems != 0 {
            var snap = mergeDataSource.snapshot()
            snap.deleteAllItems()
            mergeDataSource.apply(snap)
        }
        
    }
    
    // MARK: - Fetch Handlers
    
    func fetchMedia() {
        
        if SFContactFinder.shared.inProcess { return }
        
        guard let dataArrayType = dataArrayType else { return }

        dispatchGroup.enter()
        
        switch dataArrayType {
            
        case .allContacts:
            fetchAllContacts(SFContactFinder.shared.getAll)
        case .allDuplicates:
            fetchDuplicateContent(SFContactFinder.shared.getFullDuplicates)
        case .mergeNames:
            fetchMergeContent(SFContactFinder.shared.getNameDuplicates)
        case .mergePhones:
            fetchMergeContent(SFContactFinder.shared.getPhoneDuplicates)
        case .noName:
            fetchAllContacts(SFContactFinder.shared.getWithoutName)
        case .noPhones:
            fetchAllContacts(SFContactFinder.shared.getWithoutPhone)
        }
        
        dispatchGroup.leave()
        
    }
    
    func fetchAllContacts(_ fetchFunc: () throws -> [SFContact]) {
        
        do {
            
            let assetsArray = try fetchFunc()
            
            if assetsArray.isEmpty {
                simpleContactsArray = []
                initDataAndSnap()
                return
            }
            
            simpleContactsArray.removeAll()
            simpleContactsArray.append(assetsArray)
            
            initDataAndSnap()
            
        } catch {
            print(error.localizedDescription)
            simpleContactsArray = []
            initDataAndSnap()
        }
        
    }
    
    func fetchDuplicateContent(_ fetchFunc: () throws -> [[SFContact]]) {
        
        do {
            
            let assetsArray = try fetchFunc()

            if assetsArray.isEmpty {
                simpleContactsArray = []
                initDataAndSnap()
                return
            }
            
            simpleContactsArray = assetsArray
            
            initDataAndSnap()
            
        } catch {
            simpleContactsArray = []
            initDataAndSnap()
        }
        
    }
    
    func fetchMergeContent(_ fetchFunc: () throws -> [SFContact : [SFContact]]) {
        
        do {
            
            let assetsDictionary = try fetchFunc()
            
            if assetsDictionary.isEmpty {
                currentMergeContactsDictionary = [:]
                initDataAndSnap()
                return
            }
            
            currentMergeContactsDictionary = assetsDictionary
            
            initDataAndSnap()
            
        } catch {
            currentMergeContactsDictionary = [:]
            initDataAndSnap()
        }
        
    }
    
    //MARK: - Notifications
    
    func initNotifications() {
        
        SFNotificationSystem.observe(event: .contactFinderUpdated) { [weak self] in
            guard let self = self else { return }
            self.fetchMedia()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil
        )
        
    }
    
    func checkData(_ isEmpty: Bool) {
        
        configureRightButton(isEmpty)
        
        switch tableCellType {
        case .merge:
            contentView.setEmptyDataTitle(Generated.Text.ContactCleaner.noMerge)
            contentView.hideEmptyDataTitle(!currentMergeContactsDictionary.isEmpty)
        case .simple:
            contentView.setEmptyDataTitle(Generated.Text.ContactCleaner.noContacts)
            contentView.hideEmptyDataTitle(!simpleContactsArray.isEmpty)
        }
        
    }
    
    //MARK: - Contacts Actions
    
    func simpleCellAction(_ contact: SFContact) {
        
        do {
            let contactVC = try SFContactFinder.shared.getNativeContactController(for: contact, allowEditing: false)
            self.navigationController?.pushViewController(contactVC, animated: true)
        } catch {
            return
        }
        
    }
    
    func mergeCellAction(_ contacts: [SFContact]) {
        guard let contact = contacts.first else { return }
        
        if SFContactFinder.shared.inProcess {
            SPAlert.present(message: Generated.Text.Common.inProcess, haptic: .warning)
            return
        }
        
        do {
            if dataArrayType == .allDuplicates {
                try SFContactFinder.shared.deleteContacts(contacts.filter({ $0 != contact }))
            } else {
                try SFContactFinder.shared.saveMergeContactAndDeleteOthers(contact)
            }
            var snap = self.mergeDataSource.snapshot()
            snap.deleteItems([contacts])
            self.mergeDataSource.apply(snap)
            self.mergeContactsSearchDictionary.removeValue(forKey: contact)
            SPAlert.present(title: Generated.Text.ContactCleaner.merged, preset: .done)
            
        } catch {
            SPAlert.present(title: error.localizedDescription, preset: .error)
        }
        
    }
    
    @objc func clearAllAction() {
        
        if SFContactFinder.shared.inProcess {
            SPAlert.present(message: Generated.Text.Common.inProcess, haptic: .warning)
            return
        }
        
        let alertStringData: [String] = {
            
            guard let dataArrayType = dataArrayType else { return [] }
            
            switch dataArrayType {
                
            case .allContacts, .noPhones, .noName:
                return [Generated.Text.ContactCleaner.sureDeleteContact,
                        Generated.Text.ContactCleaner.deleteAllContacts(String(simpleContactsArray.reduce([], +).count)),
                        Generated.Text.Common.deleted]
                
            case .allDuplicates:
                return [Generated.Text.ContactCleaner.sureDeleteNames,
                        Generated.Text.ContactCleaner.deleteAllNames(String(simpleContactsArray.reduce([], +).count)),
                        Generated.Text.Common.deleted]
                
            case .mergeNames, .mergePhones:
                return [Generated.Text.ContactCleaner.sureMerge,
                        Generated.Text.ContactCleaner.mergeAllFunc(String(currentMergeContactsDictionary.count)),
                        Generated.Text.ContactCleaner.merged]
                
            }
            
        }()
        
        let alertVC = UIAlertController(title: alertStringData[0], message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: alertStringData[1], style: .destructive) { [weak self] _ in
            
            guard let self = self else { return }
            
            if !SFPurchaseManager.shared.isUserPremium {
                self.routeToPaywall()
                return
            }
            
            switch self.tableCellType {
                
            case .simple:
                do {
                    var snap = self.simpleDataSource.snapshot()
                    
                    try SFContactFinder.shared.deleteContacts(snap.itemIdentifiers)
                    
                    snap.deleteAllItems()
                    
                    self.simpleContactsArray.removeAll()
                    self.simpleDataSource.apply(snap)
                    
                    SPAlert.present(title: alertStringData[2], preset: .done)
                    SFNotificationSystem.send(event: .custom(name: "contactDeleted"))
                    
                } catch {
                    SPAlert.present(title: error.localizedDescription, preset: .error)
                }
                
            case .merge:
                
                do {
                    var snap = self.mergeDataSource.snapshot()
                    
                    let contactsToMergeArray = snap.itemIdentifiers.compactMap({$0.first})
                    
                    if self.dataArrayType == .allDuplicates {
                        try SFContactFinder.shared.deleteContacts(snap.itemIdentifiers.reduce([], +).filter({ !contactsToMergeArray.contains($0) }))
                    } else {
                        try SFContactFinder.shared.saveMergeContactsAndDeleteOthers(contactsToMergeArray)
                    }

                    snap.deleteAllItems()

                    self.currentMergeContactsDictionary.removeAll()
                    self.mergeDataSource.apply(snap)

                    SPAlert.present(title: alertStringData[2], preset: .done)
                    SFNotificationSystem.send(event: .custom(name: "contactDeleted"))

                } catch {
                    SPAlert.present(title: error.localizedDescription, preset: .error)
                }
                
            }
            
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(.init(title: Generated.Text.Common.cancel, style: .cancel))
        
        present(alertVC, animated: true)
        
    }
    
    //MARK: - Tag Actions
    
    func setupTagsActions() {
        
        contentView.setAllContactsTagViewAction { [weak self] in
            guard let self = self else { return }
            self.tagAction(.simple, .allContacts, Generated.Text.ContactCleaner.allContacts)
        }
        
        contentView.setFullDuplicateTagViewAction { [weak self] in
            guard let self = self else { return }
            self.tagAction(.simple, .allDuplicates, Generated.Text.ContactCleaner.fullDuplicates)
        }
        
        contentView.setDuplicateNamesTagViewAction { [weak self] in
            guard let self = self else { return }
            self.tagAction(.merge, .mergeNames, Generated.Text.ContactCleaner.duplicateNames)
        }
        
        contentView.setDuplicatePhonesTagViewAction { [weak self] in
            guard let self = self else { return }
            self.tagAction(.merge, .mergePhones, Generated.Text.ContactCleaner.duplicateNumbers)
        }
        
        contentView.setNoNamesTagViewAction { [weak self] in
            guard let self = self else { return }
            self.tagAction(.simple, .noName, Generated.Text.ContactCleaner.noNamesTag)
        }
        
        contentView.setNoPhonesTagViewAction { [weak self] in
            guard let self = self else { return }
            self.tagAction(.simple, .noPhones, Generated.Text.ContactCleaner.noNumbers)
        }
        
    }
    
    func tagAction(_ tableCellType: TableCellType, _ dataArrayType: ContactsArrayType, _ tagName: String) {
        
        if SFContactFinder.shared.inProcess {
            SPAlert.present(message: Generated.Text.Common.inProcess, haptic: .warning)
            return
        }
        
        if self.dataArrayType == dataArrayType { return }
        
        self.configureRightButton(true)
        self.routeHelp()
        
        self.tableCellType = tableCellType
        self.dataArrayType = dataArrayType
        
        self.contentView.getAllTags().forEach { $0.isSelected = $0.cellId == tagName }
        
        if isSearching { self.filterItems(text: self.searchController.searchBar.text) }
        
        self.contentView.hideSpinner(false)
        self.contentView.hideEmptyDataTitle(true)
        
    }
    
    //MARK: - Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            contentView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        contentView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

// MARK: - Public Methods

extension ContactCleanerViewController {
    
}

// MARK: - Private Methods

private extension ContactCleanerViewController {
    
    func setupActions() {
        setupTagsActions()
    }
    
}

// MARK: - Navigation

private extension ContactCleanerViewController {
    
    func routeToPaywall() {
        let paywallVC = AppCoordiator.shared.getPaywall()
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension ContactCleanerViewController {
    
}
