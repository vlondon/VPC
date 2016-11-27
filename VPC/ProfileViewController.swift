//
//  ProfileViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        // TODO: Clean out database
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "initialViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
}
