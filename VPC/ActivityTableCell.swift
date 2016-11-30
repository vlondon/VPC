//
//  ActivityTableCell.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

class ActivityTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    func setStatusLabelText(_ text: String) {
        self.statusLabel.text = text
        
        switch text {
        case "CONFIRMED":
            statusLabel.textColor = UIColor(red: 0.0235, green: 0.5176, blue: 0.1294, alpha: 1.0) /* #068421 */
        case "PENDING":
            statusLabel.textColor = UIColor(red: 1, green: 0.6667, blue: 0, alpha: 1.0) /* #ffaa00 */
        default:
            statusLabel.textColor = UIColor(red: 0.0157, green: 0.0667, blue: 0.0275, alpha: 1.0) /* #041107 */
        }

    }
    
}
