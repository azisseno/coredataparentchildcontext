//
//  Contact+CoreDataProperties.swift
//  LocalContact
//
//  Created by Azis Prasetyotomo on 27/11/21.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var userID: Int64
    @NSManaged public var name: String?
    @NSManaged public var phone: Int32
    @NSManaged public var picture: Data?

}

extension Contact : Identifiable {

}
