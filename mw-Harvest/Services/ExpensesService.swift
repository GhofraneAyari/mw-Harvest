//
//  ExpensesService.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/05/2022.
//

import Firebase
import FirebaseDatabase
import Foundation

class ExpensesService {
    static let instance = ExpensesService()
    let db = Firestore.firestore()

    func addInvoiceInfo(creator: String, client: String, issueDate: String, dueDate: String, amount: Double, isOpen: Bool) {
        let db = Firestore.firestore()
        db.collection("invoice")
            .document()
            .setData(["creator": creator, "client": client, "currency": "EUR", "amount": amount, "issueDate": issueDate, "dueDate": dueDate, "isOpen": true])
    }

    func deleteInvoice(with id: String) {
        db.collection("invoice").document(id).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
