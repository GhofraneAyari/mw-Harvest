//
//  InvoiceViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 05/04/2022.
//

import Firebase
import FirebaseDatabase
import Foundation
import SwiftUI
import UIKit

class InvoiceViewController: UITableViewController {
    var expensesVC: ExpensesViewController!
    var invoice: Invoice?
    

    @IBOutlet var creatorLabel: UILabel!
    @IBOutlet var clientLabel: UILabel!
    @IBOutlet var issueDateLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

//        print("im visible")

        if let invoice = invoice {
//            let amountStr : String = String (describing: invoice.amount)
            creatorLabel.text = invoice.creator
            clientLabel.text = invoice.client
            amountLabel.text = "\("€") \(invoice.amount)"
            dueDateLabel.text = "\("Due on") \(invoice.dueDate)"
        }
    }

    @IBAction func deleteInvoiceButton(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Invoice", message: "Are you sure you want to delete this invoice?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
            print("Call the deletion function here")
            deleteRow(with: invoice!.id)
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "deleteInvoice", sender: nil)
            }
            

        })
        alert.addAction(deleteAction)

//        dismiss(animated: true, completion: nil)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func deleteRow(with id: String) {
        let db = Firestore.firestore()

        db.collection("invoice").document(id).delete { [self] err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")

          
            }
        }
    }
}
