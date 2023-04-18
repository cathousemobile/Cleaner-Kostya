//
//  SecretContactsViewController.swift
//

import UIKit
import ContactsUI
import SPAlert

final class SecretContactsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SecretContactView()
    
    private lazy var searchController = UISearchController()
    
    private let clearAllButton = UIBarButtonItem()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private let dispatchGroup = DispatchGroup()
    
    private var isSearching = false
    
    private var simpleDataSource: SecretContactDiffibleDataSource!
    
    private var simpleContactsArray = [[SFContact]]() {
        didSet { checkData() }
    }
    
    private var simpleContactSearchArray = [[SFContact]]() {
        didSet {
            if oldValue != simpleContactSearchArray { initDataAndSnap() }
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

extension SecretContactsViewController {
    
    func checkAccess() {
        
        SFContactFinder.shared.requestAccess { [weak self] in
            guard let self = self else { return }
#warning("FETCH")
        } needShowDeniedAlert: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                AppCoordiator.shared.routeToSettings(Generated.Text.ContactCleaner.permissionRequared, currentVC: self)
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

extension SecretContactsViewController {
    
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

extension SecretContactsViewController: UISearchBarDelegate {
    
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
        
        
        simpleContactSearchArray.removeAll()
        
        let filteredContatsArray = simpleContactsArray.reduce([], +).filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
        filteredContatsArray.isEmpty ? simpleContactSearchArray = [] : simpleContactSearchArray.append(filteredContatsArray)
        
        
        
    }
    
}

// MARK: - TableView Config

private extension SecretContactsViewController {
    
    func configureTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.separatorStyle = .singleLine
        contentView.tableView.register(ContactCleanerTableSimpleCell.self, forCellReuseIdentifier: "cellDuplicate")
        contentView.tableView.register(ContactCleanerTableMergeCell.self, forCellReuseIdentifier: "cellMerge")
    }
    
}

// MARK: - TableView Delegate

extension SecretContactsViewController: UITableViewDelegate {
    
}

// MARK: - TableView Datasource

extension SecretContactsViewController {
    
    func initDataAndSnap() {
        
        dispatchGroup.notify(queue: .main) {
            self.initDataSource()
            self.initSnapshot()
        }
        
    }
    
    func initDataSource() {
        
        
        self.simpleDataSource = SecretContactDiffibleDataSource(tableView: self.contentView.tableView, cellProvider: { [weak self] tableView, indexPath, contactModel in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellDuplicate", for: indexPath) as! ContactCleanerTableSimpleCell
            
            cell.setContactName(contactModel.name)
            cell.setContactNumber(contactModel.numbers.first)
            
            cell.setAction {
                guard let self = self else { return }
                self.simpleCellAction(contactModel)
            }
            
            return cell
            
        })
        
        
        
    }
    
    func initSnapshot() {
        
        
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
        
        
        
    }
    
}

// MARK: - Handlers

private extension SecretContactsViewController {
    
    // MARK: - Fetch Handlers
    
    func fetchMedia() {
        
        
        dispatchGroup.enter()
        
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
    
    //MARK: - Notifications
    
    func initNotifications() {
        
        SFNotificationSystem.observe(event: .contactFinderUpdated) { [weak self] in
            guard let self = self else { return }
            self.checkData()
        }
        
        SFNotificationSystem.observe(event: .custom(name: "secretContactDeleted")) { [weak self] in
            guard let self = self else { return }
            
            self.simpleContactsArray.removeAll()
            self.simpleContactsArray.append(self.simpleDataSource.snapshot().itemIdentifiers)
            
        }
        
    }
    
    
    func checkData() {
        contentView.setEmptyDataTitle(Generated.Text.ContactCleaner.noContacts)
        contentView.hideEmptyDataTitle(!simpleContactsArray.isEmpty)
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
    
    
    
    @objc func clearAllAction() {
        
        let alertStringData: [String] = [Generated.Text.ContactCleaner.sureDeleteContact,
                                         Generated.Text.ContactCleaner.deleteAllContacts(String(simpleContactsArray.reduce([], +).count)),
                                         Generated.Text.Common.deleted]
        
        let alertVC = UIAlertController(title: alertStringData[0], message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: alertStringData[1], style: .destructive) { [weak self] _ in
            
            guard let self = self else { return }
            
            if !SFPurchaseManager.shared.isUserPremium {
                self.routeToPaywall()
                return
            }
            
            
            do {
                var snap = self.simpleDataSource.snapshot()
                
                try SFContactFinder.shared.deleteContacts(snap.itemIdentifiers)
                
                snap.deleteAllItems()
                
                self.simpleContactsArray.removeAll()
                self.simpleDataSource.apply(snap)
                
                SPAlert.present(title: alertStringData[2], preset: .done)
                SFNotificationSystem.send(event: .custom(name: "secretContactDeleted"))
                
            } catch {
                SPAlert.present(title: error.localizedDescription, preset: .error)
            }
            
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(.init(title: Generated.Text.Common.cancel, style: .cancel))
        
        present(alertVC, animated: true)
        
    }
    
}

// MARK: - Public Methods

extension SecretContactsViewController {
    
}

// MARK: - Private Methods

private extension SecretContactsViewController {
    
    func setupActions() {
        
    }
    
}

// MARK: - Navigation

private extension SecretContactsViewController {
    
    func routeToPaywall() {
        let paywallVC = AppCoordiator.shared.getPaywall()
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension SecretContactsViewController {
    
}
