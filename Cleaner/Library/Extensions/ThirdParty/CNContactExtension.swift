//
//  CNContactExtension.swift
//  Created at 19.12.2022.
//

import Foundation
import Contacts


extension CNContact {
    var contactFullnessScore: Int {
        var score = 0
        
        if self.givenName.isEmpty == false {
            score += 1
        }
        
        if self.familyName.isEmpty == false {
            score += 1
        }
        
        if self.middleName.isEmpty == false {
            score += 1
        }
        
        if self.organizationName.isEmpty == false {
            score += 1
        }
        
        if self.imageDataAvailable == true {
            score += 1
        }
        
        if self.birthday != nil {
            score += 1
        }
        
        score += self.phoneNumbers.count
        score += self.emailAddresses.count
        score += self.dates.count
        return score
    }
}
