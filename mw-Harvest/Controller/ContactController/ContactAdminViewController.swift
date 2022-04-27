//
//  ContactAdminViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 26/04/2022.
//

import Foundation
import UIKit

class ContactAdminViewController: UITableViewController{
    @IBAction func sendEmail(_ sender: Any) {
        let url = NSURL(string: "mailto:mailto:sara.cosme@mobiweb.pt")
        UIApplication.shared.open(url! as URL)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url! as URL)
        } else {
            UIApplication.shared.openURL(url! as URL)
        }
    }
    
    
    @IBAction func call(_ sender: Any) {
        let phoneNumber = "+35199999999"
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
                UIApplication.shared.canOpenURL(url) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
