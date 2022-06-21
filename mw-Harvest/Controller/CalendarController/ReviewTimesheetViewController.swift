//
//  SubmitAdminViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 17/05/2022.
//

import Firebase
import Foundation
import UIKit

class ReviewTimesheetViewController: UITableViewController {
    @Published var events = [Event]()
    @IBOutlet var tableview: UITableView!
    var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "ReviewTimesheetTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "submitCell")

        getTimeEntryData()
//        self.tableview.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let submittedEvents = events.filter { $0.is_submitted == true }
        return submittedEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let submittedEvents = events.filter { $0.is_submitted == true }
        let cell = tableView.dequeueReusableCell(withIdentifier: "submitCell", for: indexPath) as! ReviewTimesheetTableViewCell
        cell.set(event: submittedEvents[indexPath.row])
        return cell
    }

    func getTimeEntryData() {
        let db = Firestore.firestore()

        db.collection("timeEntry").addSnapshotListener { [weak self] snap, err in
            guard let self = self else {
                return
            }

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            for i in snap!.documentChanges {
                let id = i.document.documentID
                guard let client = i.document.get("client") as? String else {
                    return
                }
                guard let project = i.document.get("project") as? String else {
                    return
                }
                guard let task = i.document.get("task") as? String else {
                    return
                }
                guard let time = i.document.get("time") as? String else {
                    return
                }
                guard let is_submitted = i.document.get("is_submitted") as? Bool else {
                    return
                }

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"

                let date = dateFormatter.string(from: self.selectedDate)

                if i.type == .added {
                    print("Added")
                    self.events.append(Event(id: id, client: client, project: project, task: task, time: time, date: date, userId: UserManager.shared.userId!, is_submitted: is_submitted))
                }
                if i.type == .modified {
                    print("Modified")
                    self.events = self.events.compactMap({ event in

                        if event.id == id {
                            let eventUpdate = event
                            eventUpdate.client = client
                            eventUpdate.project = project
                            eventUpdate.task = task
                            eventUpdate.time = time
                            eventUpdate.date = date
                            return eventUpdate
                        }
                        return event

                    })
                }
                if i.type == .removed {
                    print("Removed")
                    self.events = self.events.compactMap({ event in
                        event.id == id ? nil : event
                    })
                }
            }

            self.tableView.reloadData()
        }
    }
}
