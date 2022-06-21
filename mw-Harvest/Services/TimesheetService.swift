//
//  TimesheetService.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/05/2022.
//

import Firebase
import FirebaseDatabase
import Foundation

class TimesheetService {
    static let instance = TimesheetService()
    let db = Firestore.firestore()

    func deleteTimeEntry(with id: String) {
        db.collection("timeEntry").document(id).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

    func addTimesheetEntry(userId: String, client: String, project: String, task: String, time: String, date: String) {
        let db = Firestore.firestore()
        db.collection("timeEntry")
            .document()
            .setData(["userId": userId, "client": client, "project": project, "task": task, "time": time, "date": date, "is_submitted": false])
    }

    func submitTimesheet() {
        let timeEntryCollection = db.collection("timeEntry")

        timeEntryCollection.whereField("userId", isEqualTo: UserManager.shared.userId as Any).getDocuments(completion: { documentSnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }

            guard let docs = documentSnapshot?.documents else { return }

            for doc in docs { // iterate over each document and update
                let docRef = doc.reference
                docRef.updateData(["is_submitted": true])
            }
        })
    }
}
