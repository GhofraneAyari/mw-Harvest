//
//  SubmitUserViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 17/05/2022.
//

import Firebase
import Foundation
import UIKit

class SubmitUserViewController: UIViewController {
    var event: Event?
    @Published var events = [Event]()
    @IBOutlet var checkTimesheetsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserManager.shared.userId != "d1a43029-76df-4a0c-aa7c-5d864cea94fa" {
            checkTimesheetsButton.isHidden = true
        }
    }

    @IBAction func submitTimesheetButton(_ sender: Any) {
        TimesheetService.instance.submitTimesheet()
    }
}
