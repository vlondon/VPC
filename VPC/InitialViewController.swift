//
//  InitialViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Based on "if registered" load different screen
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let userIsRegistered = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if userIsRegistered {
                let controller = storyboard.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
                controller.selectedIndex = 1
                self.present(controller, animated: true, completion: nil)
            } else {
                let controller = storyboard.instantiateViewController(withIdentifier: "registrationViewController")
                self.present(controller, animated: true, completion: nil)
            }
        }
        
    }
    
}
