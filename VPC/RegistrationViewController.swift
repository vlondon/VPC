//
//  RegistrationViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func register(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
        controller.selectedIndex = 0
        self.present(controller, animated: true, completion: nil)
        
        
    }
    
    
}

