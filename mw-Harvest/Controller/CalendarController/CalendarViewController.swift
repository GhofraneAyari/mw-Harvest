//
//  CalendarViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 14/03/2022.
//

import EventKit
import UIKit

final class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    var selectedDate = Date()
    var totalSquares = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setCellsView()
        setMonthView()
    }

    func setCellsView() {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }

    func setMonthView() {
        totalSquares.removeAll()

        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)

        var count: Int = 1

        while count <= 42 {
            if count <= startingSpaces || count - startingSpaces > daysInMonth {
                totalSquares.append("")
            } else {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }

        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell

        cell.dayOfMonth.text = totalSquares[indexPath.item]

        return cell
    }

    @IBAction func nextMonthButtonPressed(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }

    @IBAction func previousButtonPressed(_ sender: Any) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }

    override public var shouldAutorotate: Bool {
        return false
    }
}
