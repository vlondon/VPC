//
//  Parent+CoreDataClass.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

class Parent: NSManagedObject {
    static let entityName = "Parent"
}

extension Parent {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parent> {
        return NSFetchRequest<Parent>(entityName: "Parent");
    }
    
    @NSManaged public var fname: String?
    @NSManaged public var lname: String?
    @NSManaged public var mobile: String?
    @NSManaged public var email: String?
    
    class func createInManagedObjectContext(_ moc: NSManagedObjectContext, fname: String, lname: String, mobile: String, email: String) -> Parent {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: moc) as! Parent
        
        newItem.fname = fname
        newItem.lname = lname
        newItem.mobile = mobile
        newItem.email = email
        
        return newItem
    }
    
}
