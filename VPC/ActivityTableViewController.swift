//
//  ActivityTableViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//


import UIKit
import CoreData
import Alamofire

let kStatusChildConsentLogEntry = "com.trustelevate.vpc.api.data.domain.ChildConsentLogEntry"
let kStatusChildStatusLogEntry = "com.trustelevate.vpc.api.data.domain.ChildStatusLogEntry"
let kStatusChildStatusLog = "com.trustelevate.vpc.api.data.domain.ChildLog"

class ActivityTableViewController: UITableViewController {
    
    var activities = [Activity]()
    
    var kids = [String: Kid]()
    
    var selectedKid: Kid?
    
    private let managedObjectContext: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        if self.selectedKid == nil {
            tableView.allowsSelection = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let kid = selectedKid {
            self.navigationItem.title = kid.fname
        }
        
        self.getActivity()
    }
    
    func getActivity() {
        if let kid = self.selectedKid {
            let cid = kid.cid ?? ""
            self.getChildActivity(forId: cid)
        } else {
            self.getKidsActivity()
        }
    }
    
    func getChildActivity(forId cid: String) {
        let parentId = UserDefaults.standard.string(forKey: "pid")!
        
        let url = "/parent/\(parentId)/child/\(cid)/activity"
        
        NetworkService.fetchData(fromUrl: url) { [unowned self] (json, error) in
            
            var activityArray = [Any]()
            
            if let array = json?.arrayObject {
                activityArray = array
            }
            
            if let object = json?.dictionaryObject {
                activityArray.append(object)
            }
            
            if activityArray.count > 0 {
                
                do {
                    self.activities = []
                    
                    // Remove all saved activities
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
                    let request = NSBatchDeleteRequest(fetchRequest: fetch)
                    try self.managedObjectContext.execute(request)
                    
                    // Add new activities
                    for activity in activityArray {
                        let activityObject = activity as AnyObject
                        
                        let activityType = activityObject["type"] as! String
                        
                        if let activityData = activityObject["data"] as? [String: Any] {
                            
                            if let consentLog = activityData["consentLog"] as? [String: Any] {
                                
                                consentLog.values.forEach { log in
                                    let logObject = log as AnyObject
                                    let childPid = String(logObject["childPid"] as! Int)
                                    if let consent = logObject["consent"] as? [String: Any] {
                                        let parentPid = String(describing: consent["parentPid"] as! NSNumber)
                                        let serviceId = (consent["serviceId"] as? String) ?? ""
                                        let status = consent["status"] as! String
                                        
                                        Activity.createInManagedObjectContext(self.managedObjectContext, childPid: childPid, parentPid: parentPid, type: activityType, serviceId: serviceId, status: status)
                                        
                                        if let kid = self.getKid(byId: childPid) {
                                            self.kids[childPid] = kid
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    self.getActivities(forKidWith: cid)
                    
                } catch let error as NSError  {
                    print("Could not remove \(error), \(error.userInfo)")
                } catch {
                    
                }
            }
        }
    }
    
    func getKidsActivity() {
        let parentId = UserDefaults.standard.string(forKey: "pid")!
        let url = "/family/\(parentId)/activity"
        
        NetworkService.fetchData(fromUrl: url) { [unowned self] (json, error) in
            
            if let activityArray = json?.arrayObject {
                
                do {
                    self.activities = []
                    
                    // Remove all saved activities
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
                    let request = NSBatchDeleteRequest(fetchRequest: fetch)
                    try self.managedObjectContext.execute(request)
                    
                    // Add new activities
                    for activity in activityArray {
                        let activityObject = activity as AnyObject
                        let activityType = activityObject["type"] as! String
                        
                        if let activityData = activityObject["data"] as? [String: Any] {
                            
                            switch activityType {
                            case kStatusChildConsentLogEntry:
                                let childPid = String(activityData["childPid"] as! Int)
                                
                                if let consent = activityData["consent"] as? [String: Any] {
                                    let parentPid = String(describing: consent["parentPid"] as! NSNumber)
                                    let serviceId = (consent["serviceId"] as? String) ?? ""
                                    let status = consent["status"] as! String
                                    
                                    Activity.createInManagedObjectContext(self.managedObjectContext, childPid: childPid, parentPid: parentPid, type: activityType, serviceId: serviceId, status: status)
                                    
                                    if let kid = self.getKid(byId: childPid) {
                                        self.kids[childPid] = kid
                                    }
                                }
                                
                            case kStatusChildStatusLogEntry:
                                let parentPid = String(activityData["parentPid"] as! Int)
                                
                                if let child = activityData["child"] as? [String: Any] {
                                    let childPid = String(describing: child["pid"] as! NSNumber)
                                    
                                    let status = child["status"] as! String
                                    let serviceId = (child["serviceId"] as? String) ?? ""
                                    
                                    Activity.createInManagedObjectContext(self.managedObjectContext, childPid: childPid, parentPid: parentPid, type: activityType, serviceId: serviceId, status: status)
                                    
                                    if let kid = self.getKid(byId: childPid) {
                                        self.kids[childPid] = kid
                                    }
                                }
                                
                            default:
                                break
                            }
                        }
                    }
                    
                    self.getActivities(forKidWith: nil)
                    
                } catch let error as NSError  {
                    print("Could not remove \(error), \(error.userInfo)")
                } catch {
                    
                }
            }
        }
    }
    
    func getKid(byId kidId: String) -> Kid? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Kid")
        fetchRequest.predicate = NSPredicate(format: "cid == %@", kidId)
        
        do {
            let kids = try self.managedObjectContext.fetch(fetchRequest) as! [Kid]
            
            if let kid = kids.first {
                self.tableView.reloadData()
                return kid
            } else {
                print("no kid with id: \(kidId)")
                return nil
            }
        } catch {
            print("Failed to fetch kids: \(error)")
            return nil
        }
    }
    
    func getActivities(forKidWith kidId: String?) {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        if let id = kidId {
            request.predicate = NSPredicate(format: "childPid == %@", id)
        }
        
        managedObjectContext.perform {
            self.activities = try! request.execute()
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableCell
        
        let activity = activities[indexPath.row]
        if let childPid = activity.childPid {
            cell.childPid = childPid
            if let kid = self.kids[childPid] {
                cell.kid = kid
            }
        }
        
        cell.setActivityInfo(for: activity)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ActivityTableCell
        
        if cell.serviceName == kStatusChildStatusLog,
            let kid = cell.kid,
            let activity = cell.activity,
            let childPid = activity.childPid {
            
            let alert = UIAlertController(title: "Do you want to approve?", message: "Please Choose", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Approve", style: .default, handler: { action in
                self.respondToConsent(approved: true, serviceId: activity.serviceId, childPid: childPid)
            }))
            
            alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { action in
                self.respondToConsent(approved: false, serviceId: activity.serviceId, childPid: childPid)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                print("Canceled")
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func respondToConsent(approved: Bool, serviceId: String?, childPid: String) {
        var parameters: Parameters = [:]
        
        if let serviceId = serviceId {
            parameters["service"] = serviceId
        }
        
        if approved {
            parameters["approve"] = 3600
        } else {
            parameters["reject"] = 3600
        }
        
        let parentId = UserDefaults.standard.string(forKey: "pid")!
        
        NetworkService.postData(toUrl: "/parent/\(parentId)/child/\(childPid)/consent", parameters: parameters) { [unowned self] (json, error) in
            self.getChildActivity(forId: childPid)
        }
    }
    
}
