//
//  ActivityTableViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//


import UIKit
import CoreData

let kStatusChildConsentLogEntry = "com.trustelevate.vpc.api.data.domain.ChildConsentLogEntry"
let kStatusChildStatusLogEntry = "com.trustelevate.vpc.api.data.domain.ChildStatusLogEntry"

class ActivityTableViewController: UITableViewController {
    
    var activities = [Activity]()
    
    private let managedObjectContext: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        let parentId = UserDefaults.standard.string(forKey: "pid")!
        print("parentId: \(parentId)")
        
        NetworkService.fetchData(fromUrl: "/family/\(parentId)/activity") { [unowned self] (json, error) in
            print("json -> \(json)")
            
            if let activityArray = json?.arrayObject {
                print("activityArray: \(activityArray)")
                
                do {
                    // Remove all saved activities
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
                    let request = NSBatchDeleteRequest(fetchRequest: fetch)
                    try self.managedObjectContext.execute(request)
                    print("removed!")
                    
                    // Add new activities
                    activityArray.forEach { activity in
                        let activityObject = activity as AnyObject
                        print("activityObject: \(activityObject)")
                        
                        let activityType = activityObject["type"] as! String
                        print("activityType: \(activityType)")
                        
                        if let activityData = activityObject["data"] as? Dictionary<String, Any> {
                            
                            print("activityData: \(activityData)")
                            
                            switch activityType {
                            case kStatusChildConsentLogEntry:
                                let childPid = String(activityData["childPid"] as! Int)
                                
                                if let consent = activityData["consent"] as? Dictionary<String, Any> {
                                    let parentPid = String(describing: consent["parentPid"] as! NSNumber)
                                    let serviceId = "Consent Entry"
                                    let status = consent["status"] as! String
                                    
                                    Activity.createInManagedObjectContext(self.managedObjectContext, childPid: childPid, parentPid: parentPid, type: activityType, serviceId: serviceId, status: status)
                                    
                                    self.getActivity()
                                }
                                
                            case kStatusChildStatusLogEntry:
                                let parentPid = String(activityData["parentPid"] as! Int)
                                
                                if let child = activityData["child"] as? Dictionary<String, Any> {
                                    let childPid = String(describing: child["pid"] as! NSNumber)
                                    let status = child["status"] as! String
                                    let serviceId = "Status Log Entry"
                                    
                                    Activity.createInManagedObjectContext(self.managedObjectContext, childPid: childPid, parentPid: parentPid, type: activityType, serviceId: serviceId, status: status)
                                    
                                    self.tableView.reloadData()
                                }
                                
                            default:
                                break
                            }
                        }
                    }

                        
                } catch let error as NSError  {
                    print("Could not remove \(error), \(error.userInfo)")
                } catch {
                    
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getActivity()
    }
    
    func getActivity() {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        
        managedObjectContext.perform {
            self.activities = try! request.execute()
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableCell
        
        cell.nameLabel.text = activities[indexPath.row].childPid
        cell.serviceNameLabel.text = activities[indexPath.row].serviceId
        cell.statusLabel.text = activities[indexPath.row].status
        
        return cell
        
    }
    
}
