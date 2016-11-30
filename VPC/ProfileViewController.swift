//
//  ProfileViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    private let managedObjectContext: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentId = UserDefaults.standard.string(forKey: "pid") {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Parent")
            fetchRequest.predicate = NSPredicate(format: "pid == %@", parentId)
            
            do {
                let parents = try self.managedObjectContext.fetch(fetchRequest) as! [Parent]
                
                if let parent = parents.first {
                    self.firstNameLabel.text = parent.fname
                    self.lastNameLabel.text = parent.lname
                } else {
                    print("no parent with id: \(parentId)")
                    self.logoutCurrentUser()
                }
            } catch {
                fatalError("Failed to fetch kids: \(error)")
            }
        }
        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.logoutCurrentUser()
    }
    
    func logoutCurrentUser() {
        UserDefaults.standard.set(nil, forKey: "pid")
        
        // TODO: Clean out database
        
        // Remove all activities
        let fetchActivities = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        do {
            try self.managedObjectContext.execute(NSBatchDeleteRequest(fetchRequest: fetchActivities))
        } catch {
            print("Failed to delete activities: \(error)")
        }
        
        // Remove all kids
        let fetchKids = NSFetchRequest<NSFetchRequestResult>(entityName: "Kid")
        do {
            try self.managedObjectContext.execute(NSBatchDeleteRequest(fetchRequest: fetchKids))
        } catch {
            print("Failed to delete kids: \(error)")
        }
        
        // Remove all parents
        let fetchParents = NSFetchRequest<NSFetchRequestResult>(entityName: "Parent")
        do {
            try self.managedObjectContext.execute(NSBatchDeleteRequest(fetchRequest: fetchParents))
        } catch {
            print("Failed to delete parents: \(error)")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "initialViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
}
