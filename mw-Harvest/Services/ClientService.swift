//
//  ClientService.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/05/2022.
//

import Firebase
import FirebaseDatabase
import Foundation

class ClientService {
    static let instance = ClientService()
    let db = Firestore.firestore()

    func addClientInfo(name: String, address: String, currency: String, created_at: String) {
        db.collection("client")
            .document()
            .setData(["name": name, "address": address, "currency": currency, "created_at": created_at])
    }

    func deleteClient(with id: String) {
        let db = Firestore.firestore()

        db.collection("client").document(id).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
