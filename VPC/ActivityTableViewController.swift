//
//  ActivityTableViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//


import UIKit

class ActivityTableViewController: UITableViewController {
    
    var activities = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        activities.append([
            "name": "Tommy",
            "service": "Lego",
            "status": "approved"
            ])
        activities.append([
            "name": "Fiona",
            "service": "Disney",
            "status": "pending"
            ])
        activities.append([
            "name": "Max",
            "service": "Lego",
            "status": "pending"
            ])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableCell
        
        cell.nameLabel.text = activities[indexPath.row]["name"]
        cell.serviceNameLabel.text = activities[indexPath.row]["service"]
        cell.statusLabel.text = activities[indexPath.row]["status"]
        
        return cell
        
    }
    
}
