//
//  CalendarViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 14/03/2022.
//

import EventKit
import Firebase
import FirebaseDatabase
import UIKit

final class WeeklyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    var selectedDate = Date()
    @Published var events = [Event]()
    let user = UserManager.shared.user
    var event: Event?
    var totalSquares = [Date]()
    static let instance = WeeklyViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "EventTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "eventCell")

        tableView.dataSource = self
        tableView.delegate = self

        setCellsView()
        setWeekView()
        getTimeEntryData()
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

    func setCellsView() {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2)

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }

    func setWeekView() {
        totalSquares.removeAll()

        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)

        while current < nextSunday {
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }

        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
        tableView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell

        let date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))

        if date == selectedDate {
            cell.backgroundColor = UIColor.systemGreen
        } else {
            cell.backgroundColor = UIColor(named: "white")
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        collectionView.reloadData()
        tableView.reloadData()
    }

    @IBAction func previousWeek(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setWeekView()
    }

    @IBAction func nextWeek(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setWeekView()
    }

    override public var shouldAutorotate: Bool {
        return false
    }

    // TODO: Show events by date
    // TODO: Show events per user

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Event().eventsForDate(date: selectedDate).count
//        return event!.eventsForDate(date: selectedDate).count
//        return events.count

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = dateFormatter.string(from: selectedDate)
        let userid = UserManager.shared.userId
        let eventPerDate = events.filter { $0.date == today && $0.userId == userid }
        return eventPerDate.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
//        cell.set(event: events[indexPath.row])

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = dateFormatter.string(from: selectedDate)
        let eventPerDate = events.filter { $0.date == today && $0.userId == user?.id }
        cell.set(event: eventPerDate[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = events[indexPath.row].id
//            events.remove(at: indexPath.row)

            TimesheetService.instance.deleteTimeEntry(with: id)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // TODO: Get weekly hours

    func getWeeklyHours() {
        print(events.filter { $0.userId == UserManager.shared.userId })
    }
}
