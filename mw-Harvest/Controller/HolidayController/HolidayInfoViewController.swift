//
//  HolidayInfoViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 27/06/2022.
//

import Firebase
import Foundation
import UIKit

class HolidayInfoViewController: UITableViewController {
    var holiday: Holiday?
    @Published var holidays = [Holiday]()
    @IBOutlet var name: UILabel!
    @IBOutlet var leaveType: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var desc: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let holiday = holiday {
            name.text = holiday.username
            leaveType.text = holiday.leave_type
            startDate.text = holiday.start_date
            endDate.text = holiday.end_date
            desc.text = holiday.descriptin
        }
    }

    @IBAction func approveButton(_ sender: Any) {
        let db = Firestore.firestore()
        let requestRef = db.collection("holidayRequests").document(holiday!.id)

        let alert = UIAlertController(title: "Approve Holiday Request", message: "Are you sure you want to approve this request?", preferredStyle: .alert)
        let approveAction = UIAlertAction(title: "Approve", style: .default, handler: { [self] _ in
            print("Call the approve function here")
            requestRef.updateData(["is_approved": true]) { [self] error in
                if error == nil {
                    print("updated")

                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "deleteRequest", sender: nil)
                        self.tableView.reloadData()
                    }

                } else {
                    print("not updated: \(String(describing: error))")
                }
            }
        })
        alert.addAction(approveAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @IBAction func denyButton(_ sender: Any) {
        let alert = UIAlertController(title: "Deny Holiday Request", message: "Are you sure you want to deny this request?", preferredStyle: .alert)

        let denyAction = UIAlertAction(title: "Deny", style: .destructive, handler: { [self] _ in
            print("Call the deny function here")
            HolidayService.instance.denyRequest(with: holiday?.id ?? "")
            holidays = holidays.filter { $0.id == holiday?.id }

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "deleteRequest", sender: nil)
            }
            
            

        })
        alert.addAction(denyAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}
