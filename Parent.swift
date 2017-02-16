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

@objc(Parent)
class Parent: NSManagedObject {
    static let entityName = "Parent"
}

extension Parent {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parent> {
        return NSFetchRequest<Parent>(entityName: "Parent");
    }
    
    @NSManaged public var email: String?
    @NSManaged public var fname: String?
    @NSManaged public var lname: String?
    @NSManaged public var mobile: String?
    @NSManaged public var pid: String?
    
    class func createInManagedObjectContext(_ moc: NSManagedObjectContext, fname: String, lname: String, mobile: String, email: String, pid: String) -> Parent {
        
        let newItem = Parent(context: moc)
        
        newItem.fname = fname
        newItem.lname = lname
        newItem.mobile = mobile
        newItem.email = email
        newItem.pid = pid
        
        //save the object
        do {
            try moc.save()
        } catch let error as NSError  {
            print("Parent - Could not save \(error), \(error.userInfo)")
        } catch {
            print("Parent - Could not save. Unknown error.")
        }
        
        return newItem
    }
    
}
