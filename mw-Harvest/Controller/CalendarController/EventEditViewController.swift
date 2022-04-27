//
//  EventEditViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 15/03/2022.
//

import Firebase
import FirebaseDatabase
import UIKit

class EventEditViewController: UIViewController {
    @IBOutlet var clientTextField: UITextField!
    @IBOutlet var taskTextField: UITextField!
    @IBOutlet var projectTextField: UITextField!
    @IBOutlet var timePicker: UIDatePicker!
    var selectedDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()

        //Check this or else delete it
//        timePicker.date = selectedDate
    }

    @IBAction func saveAction(_ sender: Any) {
        print("save button presed")

        let hoursDateFormatter = DateFormatter()
        hoursDateFormatter.dateFormat = "HH:mm"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        let user = UserManager.shared.user

        let client = clientTextField.text
        let project = projectTextField.text
        let task = taskTextField.text
        let time = hoursDateFormatter.string(from: timePicker.date)
        let date = dateFormatter.string(from: selectedDate)
        let userId = user?.id

        if (client?.isEmpty)! && (project?.isEmpty)! && (task?.isEmpty)! {
            print("Some of the fields are empty")
            DispatchQueue.main.async {
                print("incorrect - try again")
                let alert = UIAlertController(title: "Try Again", message: "Some of the fields are empty", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                return
            }
        }
        guard let client = client, let project = project, let task = task, let userId = userId else {
            return
        }

        addEntry(userId: userId, client: client, project: project, task: task, time: time, date: date)

//        eventsList.append(newEvent)
//        navigationController?.popViewController(animated: true)
    }

    func addEntry(userId: String, client: String, project: String, task: String, time: String, date: String) {
        let db = Firestore.firestore()
        db.collection("timeEntry")
            .document()
            .setData(["userId": userId, "client": client, "project": project, "task": task, "time": time, "date": date])

//        dismiss(animated: true, completion: nil)
    }
}
