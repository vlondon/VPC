//
//  KidViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class KidViewController: UIViewController {
    
    private let managedObjectContext: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var townField: UITextField!
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        // TODO: Save
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        /* date format string rules
         * http://userguide.icu-project.org/formatparse/datetime
         */
        
        let date = dateFormatter.date(from: dobField.text!)
        
        
        let parameters: Parameters = [
            "first-name": "\(firstNameField.text!) \(lastNameField.text!)",
            "dob": dobField.text!
        ]
        
        let parentId = UserDefaults.standard.string(forKey: "pid")!
        
        NetworkService.postData(toUrl: "/parent/\(parentId)/register/child", parameters: parameters) { [unowned self] (json, error) in
            print("PARENT REGISTER json -> \(json)")
            
            print("json?.object: = \(json?.object)")
            if let childIdNew = json?.object as? Int { // from api call
                
                print("childIdNew: \(childIdNew)")
                let childIdNewString = String(childIdNew)
                
                Kid.createInManagedObjectContext(self.managedObjectContext, fname: self.firstNameField.text!, lname: self.lastNameField.text!, dob: date!, school: self.schoolField.text!, year: self.yearField.text!, town: self.townField.text!, cid: childIdNewString)
                
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
}
