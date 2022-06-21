//
//  DataService.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 26/05/2022.
//

import Firebase
import FirebaseDatabase
import Foundation

class DataService {
    static let instance = DataService()
    let db = Firestore.firestore()

    func addDocument(collection: String, userId: String, name: String) {
        db.collection(collection)
            .document()
            .setData(["userId": userId, "name": name])
    }
}
