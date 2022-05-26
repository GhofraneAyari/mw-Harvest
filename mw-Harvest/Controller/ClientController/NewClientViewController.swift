//
//  NewClientViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 28/04/2022.
//

import Firebase
import FirebaseDatabase
import Foundation
import UIKit

class NewClientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var clientName: UITextField!
    @IBOutlet var clientAddress: UITextField!
    @IBOutlet var currencyPicker: UIPickerView!

    var currencyData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

//        currencyPicker.delegate = self
//        currencyPicker.dataSource = self
        currencyData = ["EUR", "USD", "GBP", "JPY", "CAD", "CHF", "AUD"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyData[row]
    }

    @IBAction func saveAction(_ sender: Any) {
        print("Save button Pressed")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = Date()

        guard let name = clientName.text,
              let address = clientAddress.text else {
            return
        }
        let currency = currencyData[currencyPicker.selectedRow(inComponent: 0)]
        let currentDate = dateFormatter.string(from: date)

        if name.isEmpty || address.isEmpty {
            DispatchQueue.main.async {
                print("incorrect - try again")
                let alert = UIAlertController(title: "Try Again", message: "Name or address fields are empty", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                return
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "success", sender: nil)
            }
            addClientInfo(name: name, address: address, currency: currency, created_at: currentDate)
        }
    }

    func addClientInfo(name: String, address: String, currency: String, created_at: String) {
        let db = Firestore.firestore()
        db.collection("client")
            .document()
            .setData(["name": name, "address": address, "currency": currency, "created_at": created_at])
//        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
