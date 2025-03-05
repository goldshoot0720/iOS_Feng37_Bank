//
//  BankAccount+CoreDataProperties.swift
//  ios37_Feng37_Bank
//
//  Created by 鋒兄三七_二零二五 on 2025/3/5.
//
//

import Foundation
import CoreData


extension BankAccount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BankAccount> {
        return NSFetchRequest<BankAccount>(entityName: "BankAccount")
    }

    @NSManaged public var bankName: String?
    @NSManaged public var bankSaving: Int64

}

extension BankAccount : Identifiable {

}
