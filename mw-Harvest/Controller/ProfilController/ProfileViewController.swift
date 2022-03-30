//
//  ProfileViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 16/03/2022.
//

import Foundation
import UIKit
import SwiftKeychainWrapper


class ProfileViewController: UITableViewController
{
    
    @IBOutlet weak var profilImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let user = UserManager.shared.user
        fullNameLabel.text = user?.displayName
        emailLabel.text = user?.userPrincipalName
        
        
        
        let firstname = user?.givenName
        let lastname = user?.surname
        
        guard let firstname = firstname, let lastname = lastname else {
            return
        }
        
        profilImage.layer.borderWidth = 3
        profilImage.layer.masksToBounds = false
        profilImage.layer.borderColor = UIColor.gray.cgColor
        profilImage.layer.shadowColor = UIColor.gray.cgColor
        profilImage.layer.cornerRadius = profilImage.frame.height/2
        profilImage.clipsToBounds = true
        
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: 100, height: 100)
        lblNameInitialize.textColor = UIColor.white
        lblNameInitialize.text = String(firstname.first!) + String(lastname.first!)
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor.lightGray
        lblNameInitialize.layer.cornerRadius = 20
        lblNameInitialize.font = lblNameInitialize.font.withSize(50)
        
    
        
        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        profilImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        
        
        
        
    }
    
    @IBAction func sginOutButton(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "SignOut", sender: nil)
        
    }
    }
    
    
    
    
    
    
    
    
    
}
