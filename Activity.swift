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

class ActivityItem: NSManagedObject {

}

extension ActivityItem {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityItem> {
        return NSFetchRequest<ActivityItem>(entityName: "Activity");
    }
    
    
}
