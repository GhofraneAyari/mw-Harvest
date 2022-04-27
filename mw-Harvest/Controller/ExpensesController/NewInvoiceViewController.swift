//
//  NewInvoiceViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 31/03/2022.
//

import Firebase
import Foundation
import UIKit

class NewInvoiceViewController: UIViewController {
    @IBOutlet var fromTextField: UITextField!

    @IBOutlet var forTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var issueDatePicker: UIDatePicker!
    @IBOutlet var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    @IBAction func confirmButtonPressed(_ sender: Any) {
        print("confirm button pressed")
        let isOpen: Bool? = true
        // from date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        let creator = fromTextField.text
        let client = forTextField.text
        let amount = Double(amountTextField.text!)
        let issueDate = dateFormatter.string(from: issueDatePicker.date)
        let dueDate = dateFormatter.string(from: dueDatePicker.date)

        if (creator?.isEmpty)! && (client?.isEmpty)! && (amountTextField.text!.isEmpty) && (issueDatePicker.date > dueDatePicker.date) {
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

        guard let creator = creator, let amount = amount, let client = client else {
            return
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
}
