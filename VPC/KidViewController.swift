//
//  KidViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit
import CoreData
    
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
        
        Kid.createInManagedObjectContext(managedObjectContext, fname: firstNameField.text!, lname: lastNameField.text!, dob: date!, school: schoolField.text!, year: yearField.text!, town: townField.text!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
