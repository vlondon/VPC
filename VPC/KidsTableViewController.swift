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
        
        
        
        let parentId = UserDefaults.standard.string(forKey: "pid")!
        print("parentId: \(parentId)")
        
        NetworkService.fetchData(fromUrl: "/parent/\(parentId)/family") { [unowned self] (json, error) in
            print("My kids -> \(json)")
            
            if let familyObject = json?.object as? AnyObject {
                print("familyObject: \(familyObject)")
                
                do {
                    guard let dataObject = familyObject["data"] as? AnyObject else {
                        return
                    }
                    
                    guard let childrenArray = dataObject["children"] as? [AnyObject] else {
                        return
                    }
                    
                    // Get kids info by id
                    childrenArray.forEach { kid in
                        let kidObject = kid as AnyObject
                        print("Kid Object: \(kidObject)")
                        
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Kid")
                        let kidId = String(describing: kid["pid"] as! NSNumber)
                        fetchRequest.predicate = NSPredicate(format: "cid == %@", kidId)
                        
                        do {
                            let kids = try self.managedObjectContext.fetch(fetchRequest) as! [Kid]
                            
                            if let kid = kids.first {
                                self.kids.append(kid)
                                self.tableView.reloadData()
                            } else {
                                print("no kid with id: \(kidId)")
                            }
                        } catch {
                            print("Failed to fetch kids: \(error)")
                        }
                        
                    }
                    
                    
                } catch let error as NSError  {
                    print("Could not remove \(error), \(error.userInfo)")
                } catch {
                    
                }
                
            }
        }
        
        
//        
//        let request: NSFetchRequest<Kid> = Kid.fetchRequest()
//        
//        managedObjectContext.perform {
//            self.kids = try! request.execute()
//            self.tableView.reloadData()
//        }
//        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // self.getKids()
    }
    
//    func getKids() {
//        let request: NSFetchRequest<Kid> = Kid.fetchRequest()
//        
//        managedObjectContext.perform {
//            self.kids = try! request.execute()
//            self.tableView.reloadData()
//        }
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kidsCell", for: indexPath) as! KidsTableCell
        
        let firstName = kids[indexPath.row].fname ?? ""
        let lastName = kids[indexPath.row].lname ?? ""
        cell.nameLabel.text = "\(firstName) \(lastName)"
        
        return cell
        
    }
    
}
