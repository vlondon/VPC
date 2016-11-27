//
//  KidsTableViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

class KidsTableViewController: UITableViewController {
    
    var kids = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kids.append("Tommy")
        self.kids.append("Fiona")
        self.kids.append("Max")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kidsCell", for: indexPath) as! KidsTableCell
        
        cell.nameLabel.text = kids[indexPath.row]
        
        return cell
        
    }
    
}
