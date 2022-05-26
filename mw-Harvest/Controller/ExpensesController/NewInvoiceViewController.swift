//
//  NewInvoiceViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 31/03/2022.
//

import Firebase
import Foundation
import UIKit

class NewInvoiceViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var fromTextField: UITextField! // Billing company
    @IBOutlet var forTextField: UITextField! // Client
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var issueDatePicker: UIDatePicker!
    @IBOutlet var amountTextField: UITextField!

    var client: Client?
    @Published var clients = [Client]()
    var clientNames: [String] = [String]()
    var companyNames: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getClientNames()
        companyNames = ["Mobiweb"]

        let clientPicker = UIPickerView()
        clientPicker.delegate = self
        clientPicker.dataSource = self
        forTextField.inputView = clientPicker

        let companyPicker = UIPickerView()
        companyPicker.delegate = self
        companyPicker.dataSource = self
        fromTextField.inputView = companyPicker

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if fromTextField.isFirstResponder {
            return companyNames.count
        } else if forTextField.isFirstResponder {
            return clientNames.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if fromTextField.isFirstResponder {
            return companyNames[row]
        } else if forTextField.isFirstResponder {
            return clientNames[row]
        }
        return nil
    }

    // TODO: Index out of range

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if forTextField.isFirstResponder {
            let itemselected = clientNames[row]
            forTextField.text = itemselected
        } else if fromTextField.isFirstResponder {
            let itemselected = companyNames[row]
            fromTextField.text = itemselected
        }
    }

    @IBAction func confirmButtonPressed(_ sender: Any) {
        print("confirm button pressed")
        let isOpen: Bool? = true
        // from date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        guard let creator = fromTextField.text,
              let client = forTextField.text,
              let amount = Double(amountTextField.text!) else {
            return
        }

        let issueDate = dateFormatter.string(from: issueDatePicker.date)
        let dueDate = dateFormatter.string(from: dueDatePicker.date)

        if creator.isEmpty || client.isEmpty || (amountTextField.text!.isEmpty) || (issueDatePicker.date > dueDatePicker.date) {
            print("Some of the fields are empty")
            DispatchQueue.main.async {
                print("incorrect - try again")
                let alert = UIAlertController(title: "Try Again", message: "Some of the fields are empty", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                return
            }
        }

        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: amountTextField.text!)) {
            print("Amount is not a number")
            DispatchQueue.main.async {
                print("incorrect - try again")
                let alert = UIAlertController(title: "Try Again", message: "Amount should be a valid number", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                return
            }
        }

        addInfo(creator: creator, client: client, issueDate: issueDate, dueDate: dueDate, amount: amount, isOpen: isOpen ?? true)
    }

    func addInfo(creator: String, client: String, issueDate: String, dueDate: String, amount: Double, isOpen: Bool) {
        let db = Firestore.firestore()
        db.collection("invoice")
            .document()
            .setData(["creator": creator, "client": client, "currency": "EUR", "amount": amount, "issueDate": issueDate, "dueDate": dueDate, "isOpen": true])

        dismiss(animated: true, completion: nil)
    }

    func getClientNames() {
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
    }
}
