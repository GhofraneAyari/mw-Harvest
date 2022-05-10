//
//  ProfileViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 16/03/2022.
//

import Firebase
import FirebaseDatabase
import Foundation
import SwiftKeychainWrapper
import UIKit

class ProfileViewController: UITableViewController {
    @IBOutlet var profilImage: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet weak var weeklyHoursLabel: UILabel!
    var hours: [Int] = [Int]()
    var uids : [String] = [String]()
    let user = UserManager.shared.user

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        var hoursByUser = Dictionary(uniqueKeysWithValues: zip(uids, hours))
        hoursByUser = hoursByUser.filter({ $0.key == user?.id})
        let userHours = hoursByUser.map { $0.1 }
        let sumHours = userHours.reduce(0, +)

        fullNameLabel.text = user?.displayName
        emailLabel.text = user?.userPrincipalName
        weeklyHoursLabel.text = String(sumHours)
        print(hours)
        print(uids)
        print(sumHours)

        let firstname = user?.givenName
        let lastname = user?.surname

        guard let firstname = firstname, let lastname = lastname else {
            return
        }

        profilImage.layer.borderWidth = 3
        profilImage.layer.masksToBounds = false
        profilImage.layer.borderColor = UIColor.gray.cgColor
        profilImage.layer.shadowColor = UIColor.gray.cgColor
        profilImage.layer.cornerRadius = profilImage.frame.height / 2
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
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Sign out", style: .destructive, handler: { _ in

            KeychainWrapper.standard.removeObject(forKey: "accessToken")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "SignOut", sender: nil)
            }
        })
        alert.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func weeklyHours() {
        let db = Firestore.firestore()
        

        db.collection("timeEntry").document().addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let time = document.get("time") as? String else {
                return
            }
            guard let uid = document.get("userId") as? String else {
                return
            }
            let intTime = Int(time)
            self.hours.append(intTime ?? 0)
            self.uids.append(uid)
        }
        
    }
}
