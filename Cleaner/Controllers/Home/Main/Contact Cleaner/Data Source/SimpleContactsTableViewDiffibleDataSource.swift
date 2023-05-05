//
//  ContactTableViewDiffibleDataSource.swift
//

import UIKit

class SimpleContactsTableViewDiffibleDataSource: UITableViewDiffableDataSource<String, SFContact> {
    
    var lastDeletedItem: SFContact? {
        didSet {
            SFNotificationSystem.send(event: .custom(name: "contactDeleted"))
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let user = self.itemIdentifier(for: IndexPath(item: 0, section: section)) else { return nil }
        
        return self.snapshot().sectionIdentifier(containingItem: user)
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.snapshot().sectionIdentifiers
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        if let id = self.itemIdentifier(for: indexPath) {
            
            do {
                try SFContactFinder.shared.deleteContacts([id])
                var snap = self.snapshot()
                snap.deleteWithSections([id])
                self.apply(snap)
                lastDeletedItem = id
            } catch {
                
            }
            
        }
        
    }
    
}
