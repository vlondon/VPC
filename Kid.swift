//
//  Kid.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Kid)
class Kid: NSManagedObject {
    static let entityName = "Kid"
}

extension Kid {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kid> {
        return NSFetchRequest<Kid>(entityName: self.entityName);
    }
    
    @NSManaged public var fname: String?
    @NSManaged public var lname: String?
    @NSManaged public var dob: Date?
    @NSManaged public var school: String?
    @NSManaged public var year: String?
    @NSManaged public var town: String?
    
    class func createInManagedObjectContext(_ moc: NSManagedObjectContext, fname: String, lname: String, dob: Date, school: String, year: String, town: String) -> Kid {
        // let newItem = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: moc) as! Kid
        
        let newItem = Kid(context: moc)
        
        newItem.fname = fname
        newItem.lname = lname
        newItem.dob = dob
        newItem.school = school
        newItem.year = year
        newItem.town = town
        
        return newItem
    }
    
}
