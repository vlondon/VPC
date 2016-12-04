//
//  UIViewController+Keyboard.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 04/12/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

