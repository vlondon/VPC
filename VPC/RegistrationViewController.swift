//
//  RegistrationViewController.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var registerButtonBottomConstraint: NSLayoutConstraint!
    
    private let managedObjectContext: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        
        // TODO: register parent
        
        let parameters: Parameters = [
            "name": "\(firstName.text!) \(lastName.text!)",
            "mobile": mobileNumber.text!,
            "email": email.text!
        ]
        
        NetworkService.postData(toUrl: "/parent/register", parameters: parameters) { [unowned self] (json, error) in
            print("PARENT REGISTER json -> \(json)")
            
            print("json?.object: = \(json?.object)")
            if let parentIdNew = json?.object as? Int { // from api call
            
                let parentIdNew = String(parentIdNew)
                
                let parent = Parent.createInManagedObjectContext(self.managedObjectContext, fname: self.firstName.text!, lname: self.lastName.text!, mobile: self.mobileNumber.text!, email: self.email.text!, pid: parentIdNew)
                
                if let parentId = parent.pid {
                    UserDefaults.standard.set(parentId, forKey: "pid")
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
                controller.selectedIndex = 0
                // TODO: controller.parent = parent
                self.present(controller, animated: true, completion: nil)
            }
            
        }
    }
    
    // MARK: Keyboard events
    
    func keyboardWasShown(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.registerButtonBottomConstraint.constant = keyboardSize.height + 20
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.registerButtonBottomConstraint.constant = 40
        }
    }
    
}

