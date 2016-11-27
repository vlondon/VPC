//
//  KidsTableViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit
import CoreData

class KidsTableViewController: UITableViewController {
    
    var kids = [Kid]()
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a new fetch request using the KidItem entity
//        let request: NSFetchRequest<Kid> = Kid.fetchRequest()
//        
//        // Execute the fetch request, and cast the results to an array of LogItem objects
//        do {
//            let searchResults = try request.execute()
//            self.kids = searchResults
//            self.tableView.reloadData()
//        } catch {
//            print("Error with request: \(error)")
//        }
        let request: NSFetchRequest<Kid> = Kid.fetchRequest()
        
        managedObjectContext.perform {
            self.kids = try! request.execute()
            self.tableView.reloadData()
        }
        
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        let entity = NSEntityDescription.entity(forEntityName: "Kid",
//                                                in: managedContext)!
//        
//        let person = NSManagedObject(entity: entity,
//                                     insertInto: managedContext)
//        
//        person.setValue(name, forKeyPath: "name")
//        
//        do {
//            try managedContext.save()
//            people.append(person)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kidsCell", for: indexPath) as! KidsTableCell
        
        cell.nameLabel.text = kids[indexPath.row].fname
        
        return cell
        
    }
    
}
