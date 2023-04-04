//
//  ContactTableViewDiffibleDataSource.swift
//

import UIKit

class ContactTableViewDiffibleDataSource: UITableViewDiffableDataSource<String, MyContact> {
    
    var lastDeletedItem: MyContact? {
        didSet {
            AppNotificationService.send(event: .contactDeleted)
        }
    }
    
    var dataStyle: ContactCleanerViewController.TableCellType?
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard dataStyle == .duplicate else { return nil }
        guard let user = self.itemIdentifier(for: IndexPath(item: 0, section: section)) else { return nil }
        
        return self.snapshot().sectionIdentifier(containingItem: user)
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard dataStyle == .duplicate else { return nil }
        return self.snapshot().sectionIdentifiers
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard dataStyle == .duplicate else { return false }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard dataStyle == .duplicate else { return }
        guard editingStyle == .delete else { return }
        
        if let id = self.itemIdentifier(for: indexPath) {
            var snap = self.snapshot()
            snap.deleteWithSections([id])
            self.apply(snap)
            lastDeletedItem = id
        }
        
    }
    
}
