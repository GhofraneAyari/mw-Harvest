//
//  SubmittedHolidayListViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 21/06/2022.
//

import Firebase
import Foundation
import UIKit

class SubmittedHolidayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @Published var holidays = [Holiday]()
    @IBOutlet var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.setEmptyMessage("No holiday requests at the moment.")

        let cellNib = UINib(nibName: "SubmittedHolidayTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "holidayCell")

        tableview.dataSource = self
        tableview.delegate = self

        getHolidayData()
        tableview.reloadData()
    }

    func getHolidayData() {
        let db = Firestore.firestore()

        db.collection("holidayRequests").addSnapshotListener { [weak self] snap, err in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            for i in snap!.documentChanges {
                let id = i.document.documentID
                guard let leaveType = i.document.get("leave_type") as? String else {
                    return
                }
                guard let startDate = i.document.get("start_date") as? String else {
                    return
                }
                guard let endDate = i.document.get("end_date") as? String else {
                    return
                }
                guard let description = i.document.get("description") as? String else {
                    return
                }
                guard let is_approved = i.document.get("is_approved") as? Bool else {
                    return
                }
                guard let username = i.document.get("username") as? String else {
                    return
                }

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"

                let date = dateFormatter.string(from: Date())

//                if i.type == .added {
//                    print("Added")
//                    self.holidays.append(Holiday(id: id, leave_type: leaveType, start_date: startDate, end_date: endDate, description: description, is_approved: is_approved, username: username, created_at: date))
//                }
//                if i.type == .modified {
//                    print("Modified")
//                }
//                if i.type == .removed {
//                    print("Removed")
//                    self.holidays = self.holidays.compactMap({ holiday in
//                        holiday.id == id ? nil : holiday
//                    })
//                }

                self?.holidays.append(Holiday(id: id, leave_type: leaveType, start_date: startDate, end_date: endDate, description: description, is_approved: is_approved, username: username, created_at: date))
            }

            self?.tableview.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let requestedHolidays = holidays.filter { $0.is_approved == false }
        tableview.backgroundView?.isHidden = !requestedHolidays.isEmpty
        return requestedHolidays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let requestedHolidays = holidays.filter { $0.is_approved == false }
        let cell = tableView.dequeueReusableCell(withIdentifier: "holidayCell", for: indexPath) as! SubmittedHolidayTableViewCell
        cell.set(holiday: requestedHolidays[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "requestInfo", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "requestInfo",
           let holidayVC = segue.destination as? HolidayInfoViewController,
           let indexPath = sender as? IndexPath {
            let holiday = holidays[indexPath.row]
            holidayVC.holiday = holiday
        }
    }
}
