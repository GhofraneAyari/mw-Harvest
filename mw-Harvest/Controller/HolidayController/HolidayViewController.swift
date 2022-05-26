//
//  HolidayViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 02/05/2022.
//

import Foundation
import MessageUI
import UIKit
import Firebase
import FirebaseDatabase

class HolidayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate {
    @IBOutlet var leaveTypePicker: UIPickerView!
    @IBOutlet var startDate: UIDatePicker!
    @IBOutlet var descriptionLabel: UITextField!
    @IBOutlet var endDate: UIDatePicker!
    var leaveTypeData: [String] = [String]()
    let user = UserManager.shared.user

    override func viewDidLoad() {
        super.viewDidLoad()

        leaveTypePicker.delegate = self
        leaveTypePicker.dataSource = self

        leaveTypeData = ["Sick leave", "Casual leave", "Maternity leave", "Paternity leave", "Bereavement leave", "Compensatory leave", "Sabbatical leave", "Unpaid Leave", "Religious holiday", "Regional holiday"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leaveTypeData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return leaveTypeData[row]
    }

    @IBAction func saveAction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let startdate = dateFormatter.string(from: startDate.date)
        let enddate = dateFormatter.string(from: endDate.date)
        let leaveType = leaveTypeData[leaveTypePicker.selectedRow(inComponent: 0)]
        
        if startDate.date > endDate.date {
            print("Start date can't be after end date")
            DispatchQueue.main.async {
                print("incorrect - try again")
                let alert = UIAlertController(title: "Try Again", message: "Start date can't be after end date.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                return
            }
        } else {
            let alert = UIAlertController(title: "Submit holiday", message: "Do you approve of sending a generated email to HR?", preferredStyle: .alert)
            let holidayAction = UIAlertAction(title: "Submit holiday", style: .destructive, handler: { _ in
                self.sendEmail()
                self.addholidayInfo(userId: self.user?.id ?? "", username: self.user?.displayName ?? "", leave_type: leaveType, start_date: startdate, end_date: enddate, description: self.descriptionLabel.text ?? "", is_approved: false)
                //            let success = UIAlertController(title: "Success", message: "Holiday request was successful", preferredStyle: .alert)

                //            DispatchQueue.main.async {
                //                self.performSegue(withIdentifier: "SignOut", sender: nil)
                //            }
            })
            alert.addAction(holidayAction)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)

            present(alert, animated: true, completion: nil)
        }
    }

    func sendEmail() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let startdate = dateFormatter.string(from: startDate.date)
        let enddate = dateFormatter.string(from: endDate.date)
        let leaveType = leaveTypeData[leaveTypePicker.selectedRow(inComponent: 0)]
        let username = user?.displayName

        let email = "sara.cosme@mobiweb.pt"
        let subject = "Request a \(leaveType)"
        let body = "Dear human ressources team,\n \nI am writing to ask for a \(leaveType) in advance of my entitlements. \nI'd like to take my leave between the following dates: \(startdate) and \(enddate).\nThank you for taking my request into consideration,\n \nSincerely,\n--\(username ?? "")"

        let url = NSURL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")")
        UIApplication.shared.open(url! as URL)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url! as URL)
        } else {
            UIApplication.shared.openURL(url! as URL)
        }

        print(body)
    }
    
    func addholidayInfo(userId: String, username: String, leave_type: String, start_date: String, end_date: String, description: String, is_approved: Bool) {
        let db = Firestore.firestore()
        db.collection("holidayRequests")
            .document()
            .setData(["userId": userId, "username": username, "leave_type" : leave_type, "start_date" : start_date, "end_date" : end_date, "description": description, "is_approved" : is_approved])
    }
}
