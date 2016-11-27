//
//  InitialViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

class InitialViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Based on if parent is registered/logged in - load different screen
        
        if let parentId = UserDefaults.standard.string(forKey: "pid") {
            print("we know parent -> \(parentId)")
            
            let userIsRegistered = true // TODO: check for parent by id in Core Data
            
            if userIsRegistered {
                self.showMainTabBar()
            } else {
                self.showRegistration()
            }
        } else {
            self.showRegistration()
        }
        
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        
        // }
        
    }
    
    func showMainTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
        controller.selectedIndex = 1
        self.present(controller, animated: true, completion: nil)
    }
    
    func showRegistration() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "registrationViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
}
