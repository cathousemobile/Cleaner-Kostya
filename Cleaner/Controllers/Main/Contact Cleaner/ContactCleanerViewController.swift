//
//  ContactCleanerViewController.swift
//

import UIKit
import ContactsUI
import SPAlert

final class ContactCleanerViewController: UIViewController {
    
    enum ContactsArrayType {
        case name
        case phones
        case merge
    }
    
    enum TableCellType {
        case duplicate
        case merge
    }
    
    // MARK: - UI Elements
    
    private let contentView = ContactCleanerView()
    
    private lazy var searchController = UISearchController()
    
    private let clearAllButton = UIBarButtonItem()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private var dataArrayType: ContactsArrayType = .name
    
    private var tableCellType: TableCellType = .duplicate {
        didSet {
            guard oldValue != tableCellType else {return}
            initDataSource()
            contentView.tableView.separatorStyle = tableCellType == .merge ? .none : .singleLine
            clearAllButton.title = tableCellType == .merge ? Generated.Text.ContactCleaner.mergeAll : Generated.Text.ContactCleaner.cleanAll
        }
    }
    
    private var dataSource: ContactTableViewDiffibleDataSource!
    
    private var contactsSearch = [MyContact]()
    
    private var currentContacts: [MyContact]  {
        get {
            switch dataArrayType {
            case .name:
                return contactsNames
            case .phones:
                return contactsPhones
            case .merge:
                return contactsMerge
            }
        }
        set {
            switch dataArrayType {
            case .name:
                contactsNames = newValue
            case .phones:
                contactsPhones = newValue
            case .merge:
                contactsMerge = newValue
            }
        }
    }
    
    private var contactsNames: [MyContact] = [MyContact(id: "asdad", name: "Aasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "aasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Basya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Basya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Casya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Casya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Dasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Dasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Easya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Easya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Fasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Fasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Gasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Gasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Hasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Hasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Jasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Jasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Kasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Kasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Lasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Lasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Masya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: ".asya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "!asya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "#asya", stringPhoneNumber: ["88889999888"])]
    
    private var contactsPhones: [MyContact] = [MyContact(id: "asdad", name: "Aasya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: "aasya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: "Basya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: "Basya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: "Kasya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: "Lasya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: "Lasya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: "Masya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: ".asya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: "!asya", stringPhoneNumber: ["88889999888"]),
                                               MyContact(id: "asdad", name: "#asya", stringPhoneNumber: ["88889999888"])]
    
    private var contactsMerge: [MyContact] = [MyContact(id: "asdad", name: "Aasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: ".asya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "!asya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "#asya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Gasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Gasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Hasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Hasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Jasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Jasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Kasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Kasya", stringPhoneNumber: ["88889999888"]),
                                              MyContact(id: "asdad", name: "Lasya", stringPhoneNumber: ["88889999888"])]
    
    
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
        
        setupActions()
        configureTableView()
        configureSearchController()
        initNotifications()
        initNavigationBarItems()
        
        //        DispatchQueue.global(qos: .background).async {
        //            self.contacts = ContactsService.getAllContacts().sorted(by: { $0.name.lowercased() < $1.name.lowercased() } )
        
        DispatchQueue.main.async {
            self.initDataSource()
            self.initSnapshot(self.currentContacts)
        }
        
        //        }
        
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
        
        guard let text = text else { return }
        
        contactsSearch = text.isEmpty ? currentContacts : currentContacts.filter({ $0.name.lowercased().contains(text.lowercased()) })
        
        initSnapshot(contactsSearch)
    }
    
}

// MARK: - TableView Config

private extension ContactCleanerViewController {
    
    func configureTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.register(ContactCleanerTableDuplicateCell.self, forCellReuseIdentifier: "cellDuplicate")
        contentView.tableView.register(ContactCleanerTableMergeCell.self, forCellReuseIdentifier: "cellMerge")
    }
    
}

// MARK: - TableView Delegate

extension ContactCleanerViewController: UITableViewDelegate {
    
}

// MARK: - TableView Datasource

extension ContactCleanerViewController {
    
    func initDataSource() {
        
        switch tableCellType {
            
        case .duplicate:
            
            dataSource = ContactTableViewDiffibleDataSource(tableView: contentView.tableView, cellProvider: { [unowned self] tableView, indexPath, contactModel in
                let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "cellDuplicate", for: indexPath) as! ContactCleanerTableDuplicateCell
                cell.setContactName(contactModel.name)
                cell.setContactNumber(contactModel.stringPhoneNumber[0])
                
                return cell
            })
            
            dataSource.dataStyle = .duplicate
            
        case .merge:
            
            dataSource = ContactTableViewDiffibleDataSource(tableView: contentView.tableView, cellProvider: { [unowned self] tableView, indexPath, contactModel in
                let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "cellMerge", for: indexPath) as! ContactCleanerTableMergeCell
                cell.setContactName(contactModel.name)
                cell.addContactsToMergeList(2, contactName: contactModel.name, contactPhone: contactModel.stringPhoneNumber[0])
                cell.setAction { [unowned self] in
                    mergeContacts(indexPath)
                }
                
                return cell
            })
            
            dataSource.dataStyle = .merge
            
        }
        
    }
    
    func initSnapshot(_ dataArray: [MyContact]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, MyContact>()
        
        switch tableCellType {
            
        case .duplicate:
            let dic = Dictionary(grouping: dataArray) { $0.name.uppercased().first }
            
            let sections = Array(String(dic.compactMap( {$0.key } )).uppercased()).compactMap {"\($0)"}.sorted(by: { $0 < $1 })
            
            snapshot.appendSections(sections)
            
            sections.forEach { section in
                if let items = dic[Character(section)] {
                    snapshot.appendItems(items, toSection: section)
                }
            }
            
        case .merge:
            snapshot.appendSections(["main"])
            snapshot.appendItems(dataArray.sorted(by: { $0.name.first! < $1.name.first! }), toSection: "main")
            
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
}

// MARK: - Handlers

private extension ContactCleanerViewController {
    
    func initNotifications() {
        
        AppNotificationService.observe(event: .contactDeleted) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.currentContacts = strongSelf.currentContacts.filter({ $0.name != strongSelf.dataSource.lastDeletedItem?.name })
            strongSelf.checkData()
        }
        
    }
    
    func checkData() {
        
        if currentContacts.isEmpty {
            
            switch dataArrayType {
                
            case .name:
                contentView.setEmptyDataTitle(Generated.Text.ContactCleaner.noNames)
                
            case .phones:
                contentView.setEmptyDataTitle(Generated.Text.ContactCleaner.noContacts)
                
            case .merge:
                contentView.setEmptyDataTitle(Generated.Text.ContactCleaner.noMerge)
                
            }
            
            contentView.hideEmptyDataTitle(false)
            
        } else {
            contentView.hideEmptyDataTitle(true)
        }
    }
    
    @objc func clearAllAction() {
        
        let alertStringData: [String] = {
            
            switch dataArrayType {
                
            case .name:
                return [Generated.Text.ContactCleaner.sureDeleteContact,
                        Generated.Text.ContactCleaner.deleteAllContacts(String(currentContacts.count)),
                        Generated.Text.Common.deleted]
                
            case .phones:
                return [Generated.Text.ContactCleaner.sureDeleteNames,
                        Generated.Text.ContactCleaner.deleteAllNames(String(currentContacts.count)),
                        Generated.Text.Common.deleted]
                
            case .merge:
                return [Generated.Text.ContactCleaner.sureMerge,
                        Generated.Text.ContactCleaner.mergeAllFunc(String(currentContacts.count)),
                        Generated.Text.ContactCleaner.merged]
                
            }
            
        }()
        
        let alertVC = UIAlertController(title: alertStringData[0], message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: alertStringData[1], style: .destructive) { [unowned self] _ in
            
            if !LocaleStorage.isPremium {
                routeToPaywall()
                return
            }
            
            var snap = dataSource.snapshot()
            snap.deleteAllItems()
            currentContacts = snap.itemIdentifiers
            dataSource.apply(snap)
            SPAlert.present(title: alertStringData[2], preset: .done)
            checkData()
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(.init(title: Generated.Text.Common.cancel, style: .cancel))
        
        present(alertVC, animated: true)
        
    }
    // MARK: - ToDo
    func mergeContacts(_ indexPath: IndexPath) {
        
        if let id = self.dataSource.itemIdentifier(for: indexPath) {
            self.dataSource.lastDeletedItem = id
            var snap = self.dataSource.snapshot()
            snap.deleteItems([id])
            
            dataSource.apply(snap, animatingDifferences: true)
            
//            DispatchQueue.main.async { [weak self] in
//                self?.dataSource.apply(snap, animatingDifferences: true) {
////                    self?.contentView.tableView.reloadData()
//                    self?.dataSource.apply(snap, animatingDifferences: false)
//                }
//            }

            
        }
        
    }
    
    func setupTagsActions() {
        
        contentView.setNameTagViewAction { [unowned self] in
            dataArrayType = .name
            checkData()
            tableCellType = .duplicate
            initSnapshot(currentContacts)
            contentView.getAllTags().forEach { $0.isSelected = $0.cellId == Generated.Text.ContactCleaner.duplicateNames }
            filterItems(text: searchController.searchBar.text)
        }
        
        contentView.setPhoneTagViewAction { [unowned self] in
            dataArrayType = .phones
            checkData()
            tableCellType = .duplicate
            initSnapshot(currentContacts)
            contentView.getAllTags().forEach { $0.isSelected = $0.cellId == Generated.Text.ContactCleaner.duplicateNumbers }
            filterItems(text: searchController.searchBar.text)
        }
        
        contentView.setMergeTagViewAction { [unowned self] in
            dataArrayType = .merge
            checkData()
            tableCellType = .merge
            initSnapshot(currentContacts)
            contentView.getAllTags().forEach { $0.isSelected = $0.cellId == Generated.Text.ContactCleaner.merge }
            filterItems(text: searchController.searchBar.text)
        }
        
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

extension ContactCleanerViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contacts: [CNContact]) {
        
    }
    
}
