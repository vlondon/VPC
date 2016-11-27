//
//  RegistrationViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {

    private let managedObjectContext: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        
        let parent = Parent.createInManagedObjectContext(self.managedObjectContext, fname: "", lname: "", mobile: "", email: "")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
        controller.selectedIndex = 0
        // TODO: controller.parent = parent
        self.present(controller, animated: true, completion: nil)
        
        
    }
    
    
}

