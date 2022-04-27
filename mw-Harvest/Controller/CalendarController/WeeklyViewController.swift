//
//  CalendarViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 14/03/2022.
//

import EventKit
import Firebase
import FirebaseDatabase
import KVKCalendar
import UIKit

var selectedDate = Date()

final class WeeklyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    

    @Published var events = [Event]()

    let user = UserManager.shared.user

    var event: Event?

    var totalSquares = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "EventTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "eventCell")
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self

        setCellsView()
        setWeekView()
        getTimeEntryData()
    }

    func getTimeEntryData() {
        let db = Firestore.firestore()

        db.collection("timeEntry").addSnapshotListener { [self] snap, err in

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

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"

                let date = dateFormatter.string(from: selectedDate)

                if i.type == .added {
                    print("Added")
                }
                if i.type == .modified {
                    print("Modified")
                }
                if i.type == .removed {
                    print("Removed")
                }

                self.events.append(Event(id: id, client: client, project: project, task: task, time: time, date: date, userId: UserManager.shared.userId!))
//                if let row = self.events.count as? Any {
//                    let indexPath = IndexPath(row: row as! Int - 1, section: 0)
//                    self.tableView.insertRows(at: [indexPath], with: .automatic)
//                }
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Event().eventsForDate(date: selectedDate).count
//        return event!.eventsForDate(date: selectedDate).count
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        cell.set(event: events[indexPath.row])
        return cell
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    func getWeeklyHours() {
        print(events.filter { $0.userId == UserManager.shared.userId })
    }
}
