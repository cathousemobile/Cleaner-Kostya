//
//  NSDiffableDataSourceSnapshot+Extension.swift
//

import UIKit

extension NSDiffableDataSourceSnapshot {
    
    mutating func deleteWithSections(_ items : [ItemIdentifierType]) {
        self.deleteItems(items)
        let empties = self.sectionIdentifiers.filter { self.numberOfItems(inSection: $0) == 0 }
        self.deleteSections(empties)
    }
    
}
