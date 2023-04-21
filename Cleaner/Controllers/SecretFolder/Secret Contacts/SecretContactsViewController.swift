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
    
    private var cnVC = CNContactViewController()
    
    private let dispatchGroup = DispatchGroup()
    
    private var isSearching = false
    
    private var simpleDataSource: SecretContactDiffibleDataSource!
    
    private var simpleContactsArray = [SFContact]() {
        didSet { checkData() }
    }
    
    private var simpleContactSearchArray = [SFContact]() {
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
        title = Generated.Text.SecretFolder.contacts
        initData()
        fetchMedia()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initNavigationBarItems()
        contentView.lockAddButton(!SFPurchaseManager.shared.isUserPremium)
    }
    
}

// MARK: - Init

extension SecretContactsViewController {
    
    func checkAccess(_ successCompletion: @escaping EmptyBlock) {
        
        SFContactFinder.shared.requestAccess {
            successCompletion()
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
        
        if !simpleContactsArray.isEmpty {
            clearAllButton.title = Generated.Text.ContactCleaner.cleanAll
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
        
        simpleContactSearchArray = simpleContactsArray.filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
        
    }
    
}

// MARK: - TableView Config

private extension SecretContactsViewController {
    
    func configureTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.separatorStyle = .singleLine
        contentView.tableView.register(ContactCleanerTableSimpleCell.self, forCellReuseIdentifier: "cellDuplicate")
    }
    
}

// MARK: - TableView Delegate

extension SecretContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: ThisSize.is64, right: 0)
        }
        
    }
    
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
            dataArray = simpleContactSearchArray
        } else {
            dataArray = simpleContactsArray
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
        simpleContactsArray = SFContactStorage.shared.getAll()
        dispatchGroup.leave()
        
        initDataAndSnap()
        
    }
    
    //MARK: - Notifications
    
    func initNotifications() {
        
        SFNotificationSystem.observe(event: .contactStorageUpdated) { [weak self] in
            guard let self = self else { return }
            self.fetchMedia()
        }
        
        SFNotificationSystem.observe(event: .custom(name: "secretContactDeleted")) { [weak self] in
            guard let self = self else { return }
            self.simpleContactsArray = self.simpleDataSource.snapshot().itemIdentifiers
        }
        
    }
    
    
    func checkData() {
        contentView.hideEmptyDataTitle(!simpleContactsArray.isEmpty)
        configureRightButton()
    }
    
    //MARK: - Contacts Actions
    
    func simpleCellAction(_ contact: SFContact) {
        
        if let contactVC = SFContactStorage.shared.getNativeContactController(for: contact) {
            self.navigationController?.pushViewController(contactVC, animated: true)
        } else {
            SPAlert.present(title: "Error", preset: .error)
        }
        
    }
    
    @objc func clearAllAction() {
        
        let alertStringData: [String] = [Generated.Text.ContactCleaner.sureDeleteContact,
                                         Generated.Text.ContactCleaner.deleteAllContacts(String(simpleContactsArray.count)),
                                         Generated.Text.Common.deleted]
        
        let alertVC = UIAlertController(title: alertStringData[0], message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: alertStringData[1], style: .destructive) { [weak self] _ in
            
            guard let self = self else { return }
            
            if !SFPurchaseManager.shared.isUserPremium {
                self.routeToPaywall()
                return
            }
            
            var snap = self.simpleDataSource.snapshot()
            
            if SFContactStorage.shared.delete(snap.itemIdentifiers) {
                
                snap.deleteAllItems()
                
                self.simpleContactsArray.removeAll()
                self.simpleDataSource.apply(snap)
                
                SPAlert.present(title: alertStringData[2], preset: .done)
                
            } else {
                SPAlert.present(title: "Error", preset: .error)
            }
            
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(.init(title: Generated.Text.Common.cancel, style: .cancel))
        
        present(alertVC, animated: true)
        
    }
    
    func addContactAction() {
        
        if !SFPurchaseManager.shared.isUserPremium {
            self.routeToPaywall()
            return
        }
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addFromContactsAction = UIAlertAction(title: Generated.Text.SecretContacts.addFromContacts, style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            
            let pickContactVC = SFContactStorage.shared.chooseFromNotebookController { newContact in
                self.saveContact(newContact)
            }
            
            self.present(pickContactVC, animated: true)
            
        }
        
        let addNewContactsAction = UIAlertAction(title: Generated.Text.SecretContacts.createContact, style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            #warning("ждем обновления либы")
            self.cnVC = SFContactStorage.shared.createContactController() { contactToSave in
                guard let contactToSave = contactToSave else { return }
                self.saveContact(contactToSave)
                do {
                    try SFContactFinder.shared.deleteContacts([contactToSave])
                } catch {
                    print(error.localizedDescription)
                }
                self.cnVC.dismiss(animated: true)
            }
            
            let navigationController = UINavigationController(rootViewController: self.cnVC)
            self.present(navigationController, animated: true)
            
        }
        
        alertVC.addAction(addFromContactsAction)
        alertVC.addAction(addNewContactsAction)
        alertVC.addAction(.init(title: Generated.Text.Common.cancel, style: .cancel))
        
        present(alertVC, animated: true)
        
    }
    
    func saveContact(_ contactToSave: SFContact?) {
        if let contactToSave = contactToSave {
            if SFContactStorage.shared.save(contactToSave) {
                SPAlert.present(title: Generated.Text.Common.save, preset: .done)
            } else {
                SPAlert.present(title: "Error", preset: .error)
            }
        }
    }
    
}

// MARK: - Public Methods

extension SecretContactsViewController {
    
}

// MARK: - Private Methods

private extension SecretContactsViewController {
    
    func setupActions() {
        
        contentView.setAddContactAction { [weak self] in
            guard let self = self else { return }
            self.addContactAction()
        }
        
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
