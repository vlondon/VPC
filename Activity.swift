//
//  Activity.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Activity)
class Activity: NSManagedObject {
    static let entityName = "Activity"
}

extension Activity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: self.entityName);
    }
    
    @NSManaged public var childPid: String?
    @NSManaged public var parentPid: String?
    @NSManaged public var type: String?
    @NSManaged public var serviceId: String?
    @NSManaged public var status: String?
    
    class func createInManagedObjectContext(_ moc: NSManagedObjectContext, childPid: String, parentPid: String, type: String, serviceId: String, status: String) {
        
        let newItem = Activity(context: moc)
        
        newItem.childPid = childPid
        newItem.parentPid = parentPid
        newItem.type = type
        newItem.serviceId = serviceId
        newItem.status = status
        
        //save the object
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
        // return newItem
    }
}
