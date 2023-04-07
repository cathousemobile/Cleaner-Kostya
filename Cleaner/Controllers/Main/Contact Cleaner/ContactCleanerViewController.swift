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
    
    private var isSearching = false
    
    private var dataArrayType: ContactsArrayType? {
        didSet {
            if oldValue != dataArrayType { fetchMedia() }
        }
    }
    
    private var tableCellType: TableCellType = .simple {
        didSet {
            guard oldValue != tableCellType else {return}
            contentView.tableView.separatorStyle = tableCellType == .merge ? .none : .singleLine
            clearAllButton.title = tableCellType == .merge ? Generated.Text.ContactCleaner.mergeAll : Generated.Text.ContactCleaner.cleanAll
        }
    }
    
    private var simpleDataSource: SimpleContactsTableViewDiffibleDataSource!
    private var mergeDataSource: MergeContactsTableViewDiffibleDataSource!
    
    private var simpleContactsArray = [[SFContact]]() {
        didSet { checkData() }
    }
    private var currentMergeContactsDictionary = [SFContact : [SFContact]]() {
        didSet { checkData() }
    }
    
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
        checkAccess()
    }
    
}

// MARK: - Init

extension ContactCleanerViewController {
    
    func checkAccess() {
        SFContactFinder.shared.requestAccess { [weak self] accessGranted in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                accessGranted ? self.dataArrayType = .allContacts : AppCoordiator.shared.routeToSettings(Generated.Text.ContactCleaner.permissionRequared, currentVC: self)
            }
            
        }
    }
    
    func initData() {
        configureSearchController()
        configureTableView()
        initNavigationBarItems()
        setupActions()
        initNotifications()
    }
    
}

// MARK: - NavigationBar Config

extension ContactCleanerViewController {
    
    func initNavigationBarItems() {
        configureRightButton()
    }
    
    func configureRightButton() {
        
        clearAllButton.title = Generated.Text.ContactCleaner.cleanAll
        clearAllButton.style = .plain
        clearAllButton.target = self
        clearAllButton.action = #selector(clearAllAction)
        clearAllButton.tintColor = Generated.Color.redWarning
        
        self.navigationItem.rightBarButtonItem = clearAllButton
        
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
        initDataSource()
        initSnapshot()
    }
    
    func initDataSource() {
        
        switch tableCellType {
            
        case .simple:
            
            simpleDataSource = SimpleContactsTableViewDiffibleDataSource(tableView: contentView.tableView, cellProvider: { [weak self] tableView, indexPath, contactModel in
                
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
            
            mergeDataSource = MergeContactsTableViewDiffibleDataSource(tableView: contentView.tableView, cellProvider: { [weak self] tableView, indexPath, contactsArray in
                
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
            
        }
        
    }
    
}

// MARK: - Handlers

private extension ContactCleanerViewController {
    
    // MARK: - Fetch Handlers
    
    func fetchMedia() {
        
        guard let dataArrayType = dataArrayType else { return }
        
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
            print(error.localizedDescription)
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
            print(error.localizedDescription)
            currentMergeContactsDictionary = [:]
            initDataAndSnap()
        }
        
    }
    
    //MARK: - Notifications
    
    func initNotifications() {
        
        SFNotificationSystem.observe(event: .contactFinderUpdated) { [weak self] in
            guard let self = self else { return }
            self.checkData()
        }
        
        SFNotificationSystem.observe(event: .custom(name: "contactDeleted")) { [weak self] in
            guard let self = self else { return }
            
            switch self.dataArrayType {
                case .allContacts, .allDuplicates, .noName, .noPhones:
                    self.simpleContactsArray.removeAll()
                    self.simpleContactsArray.append(self.simpleDataSource.snapshot().itemIdentifiers)
                
                case .mergeNames, .mergePhones:
                    self.currentMergeContactsDictionary = Dictionary(grouping: self.mergeDataSource.snapshot().itemIdentifiers.reduce([], +)) {$0}
                
                case .none:
                    print("None contacts")
                
            }
            
        }
        
    }
    
    func checkData() {
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
        
//        if !SFPurchaseManager.shared.isUserPremium {
//            routeToPaywall()
//            return
//        }
        
        do {
            try SFContactFinder.shared.saveMergeContactAndDeleteOthers(contact)
            var snap = self.mergeDataSource.snapshot()
            snap.deleteItems([contacts])
            self.mergeDataSource.apply(snap)
            self.mergeContactsSearchDictionary.removeValue(forKey: contact)
            SFNotificationSystem.send(event: .custom(name: "contactDeleted"))
            SPAlert.present(title: Generated.Text.ContactCleaner.merged, preset: .done)
            
        } catch {
            SPAlert.present(title: error.localizedDescription, preset: .error)
        }
    }
    
    @objc func clearAllAction() {
        
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
            
//            if !SFPurchaseManager.shared.isUserPremium {
//                AppCoordiator.shared.routeToPaywall(self)
//                return
//            }
            
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
                    
                    try SFContactFinder.shared.saveMergeContactsAndDeleteOthers(contactsToMergeArray)

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
        
        self.tableCellType = tableCellType
        self.dataArrayType = dataArrayType
        
        self.contentView.getAllTags().forEach { $0.isSelected = $0.cellId == tagName }
        
        if isSearching { self.filterItems(text: self.searchController.searchBar.text) }
        
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
        let paywallVC = PaywallViewController(paywallType: .oval)
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension ContactCleanerViewController {
    
}
