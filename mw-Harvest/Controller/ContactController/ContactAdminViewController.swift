//
//  ContactAdminViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 26/04/2022.
//

import Foundation
import UIKit

class ContactAdminViewController: UITableViewController {
    @IBAction func sendEmail(_ sender: Any) {
        let url = NSURL(string: "mailto:mailto:\(Constants.AdminContact.adminEmail)")
        UIApplication.shared.open(url! as URL)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url! as URL)
        } else {
            UIApplication.shared.openURL(url! as URL)
        }
    }

    @IBAction func call(_ sender: Any) {
        guard let url = URL(string: "telprompt://\(Constants.AdminContact.adminPhone)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
