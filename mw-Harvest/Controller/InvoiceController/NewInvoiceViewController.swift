//
//  NewInvoiceViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 31/03/2022.
//

import Foundation
import UIKit
import Firebase

class NewInvoiceViewController : UIViewController {
    
    @IBOutlet weak var fromTextField: UITextField!
    
    @IBOutlet weak var forTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var issueDatePicker: UIDatePicker!
    @IBOutlet weak var amountTextField: UITextField!
    
    
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        //from date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        let creator = fromTextField.text
        let client = forTextField.text
        let amount = Int(amountTextField.text!)
        let issueDate = dateFormatter.string(from:issueDatePicker.date)
        let dueDate = dateFormatter.string(from:dueDatePicker.date)
        
        
        if (creator?.isEmpty)! || (client?.isEmpty)! || (amountTextField.text!.isEmpty)
        {
            print("Some of the fields are empty")
            DispatchQueue.main.async {
                print("incorrect - try again")
                let alert = UIAlertController(title: "Try Again", message: "Some of the fields are empty", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                
                return
            }
        }
        
        
        
        guard let creator = creator else {
            return
        }
        
        guard let client = client else {
            return
        }
        
        guard let amount = amount else {
            return
        }
        
       



        
        addInfo(creator: creator, client: client, issueDate: issueDate, dueDate: dueDate, amount : amount)
    }
    
    func addInfo(creator: String, client: String, issueDate: String, dueDate: String, amount: Int) {
        
        let db = Firestore.firestore()
        db.collection("invoice")
            .document()
            .setData(["creator" : creator,"client" : client,"currency" : "EUR","amount" : amount, "issueDate" : issueDate,"dueDate" : dueDate])
    }
    
  
    
    
    
}
