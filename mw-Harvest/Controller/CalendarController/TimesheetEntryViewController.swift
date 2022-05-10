//
//  EventEditViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 15/03/2022.
//

import Firebase
import FirebaseDatabase
import UIKit

class TimesheetEntryViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var clientTextField: UITextField!
    @IBOutlet var taskTextField: UITextField!
    @IBOutlet var projectTextField: UITextField!
    @IBOutlet var timePicker: UIDatePicker!
    var selectedDate = Date()
    var clientNames: [String] = [String]()
    var taskNames: [String] = [String]()
    var projectNames: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()

        // Client text field picker view
        let clientPicker = UIPickerView()
        clientPicker.delegate = self
        clientPicker.dataSource = self
        clientTextField.inputView = clientPicker

        // Task text field picker view
        let taskPicker = UIPickerView()
        taskPicker.delegate = self
        taskPicker.dataSource = self
        taskTextField.inputView = taskPicker

        // Project text field picker view
        let projectPicker = UIPickerView()
        projectPicker.delegate = self
        projectPicker.dataSource = self
        projectTextField.inputView = projectPicker

        // Check this or else delete it
//        timePicker.date = selectedDate
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if clientTextField.isFirstResponder {
            return clientNames.count
        } else if taskTextField.isFirstResponder {
            return taskNames.count
        } else if projectTextField.isFirstResponder {
            return projectNames.count
        }

        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if clientTextField.isFirstResponder {
            return clientNames[row]
        } else if taskTextField.isFirstResponder {
            return taskNames[row]
        } else if projectTextField.isFirstResponder {
            return projectNames[row]
        }

        return nil
    }

    // TODO: Index out of range

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if clientTextField.isFirstResponder {
            let itemselected = clientNames[row]
            clientTextField.text = itemselected
        } else if taskTextField.isFirstResponder {
            let itemselected = taskNames[row]
            taskTextField.text = itemselected
        } else if projectTextField.isFirstResponder {
            let itemselected = projectNames[row]
            projectTextField.text = itemselected
        }
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

        navigationController?.popViewController(animated: true)

//        self.dismiss(animated: true, completion: nil)
    }

    func getData() {
        let db = Firestore.firestore()

        db.collection("client").addSnapshotListener { snap, err in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            for i in snap!.documentChanges {
                guard let clientName = i.document.get("name") as? String else {
                    return
                }

                self.clientNames.append(clientName)
            }
        }
        db.collection("timeEntry").addSnapshotListener { snap, err in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            for i in snap!.documentChanges {
                guard let taskName = i.document.get("task") as? String else {
                    return
                }
                guard let projectName = i.document.get("project") as? String else {
                    return
                }

                self.taskNames.append(taskName)
                self.projectNames.append(projectName)
            }
        }
    }
}
