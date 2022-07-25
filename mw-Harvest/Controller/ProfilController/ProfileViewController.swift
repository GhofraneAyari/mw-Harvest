//
//  ProfileViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 16/03/2022.
//

import Charts
import Firebase
import FirebaseDatabase
import Foundation
import SwiftKeychainWrapper
import UIKit

class ProfileViewController: UITableViewController {
    @IBOutlet var profilImage: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var weeklyHoursLabel: UILabel!
    var hours: [Int] = [Int]()
    var uids: [String] = [String]()
    let user = UserManager.shared.user
    @IBOutlet var barChartView: BarChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var hoursByUser = Dictionary(uniqueKeysWithValues: zip(uids, hours))
        hoursByUser = hoursByUser.filter({ $0.key == user?.id })
//        let userHours = hoursByUser.map { $0.1 }
//        let sumHours = userHours.reduce(0, +)

        fullNameLabel.text = user?.displayName
        emailLabel.text = user?.userPrincipalName
//        weeklyHoursLabel.text = String(sumHours)

        let firstname = user?.givenName
        let lastname = user?.surname

        guard let firstname = firstname, let lastname = lastname else {
            return
        }

        initialsPicture(image: profilImage, first: firstname, last: lastname)

        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let hours = [120.0, 115.0, 152.0, 110.0, 100.0, 96.0, 115.0, 62.0, 120.0, 0.0, 0.0, 0.0]
        setChart(dataPoints: months, values: hours)
        
        weeklyHours()
    }

    @IBAction func sginOutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)

        let signOutAction = UIAlertAction(title: "Sign out", style: .destructive, handler: { _ in

            KeychainWrapper.standard.removeObject(forKey: "accessToken")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "SignOut", sender: nil)
            }
        })
        alert.addAction(signOutAction)

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
            self.weeklyHoursLabel.text = time
        }
        
    }

    func initialsPicture(image: UIImageView, first: String, last: String) {
        image.layer.borderWidth = 3
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.shadowColor = UIColor.gray.cgColor
        image.layer.cornerRadius = profilImage.frame.height / 2
        image.clipsToBounds = true

        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: 100, height: 100)
        lblNameInitialize.textColor = UIColor.white
        lblNameInitialize.text = String(first.first!) + String(last.first!)
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor.lightGray
        lblNameInitialize.layer.cornerRadius = 20
        lblNameInitialize.font = lblNameInitialize.font.withSize(50)

        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        image.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."

        var dataEntries: [BarChartDataEntry] = []

        for i in 0 ..< dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as Any)
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Monthly hours")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData

        chartDataSet.colors = [UIColor(red: 0.392, green: 0.769, blue: 0.361, alpha: 1)]
        barChartView.animate(xAxisDuration: 3.0, yAxisDuration: 3.0)
    }
}
