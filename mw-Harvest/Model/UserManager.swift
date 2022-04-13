//
//  UserManager.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 23/03/2022.
//

import Firebase
import FirebaseDatabase
import Foundation

class UserManager {
    static let shared = UserManager()
    var user: User?
    var userId: String? {
        user?.id
    }

//    init () {
//        userId = SaveUser()
//    }

    class SaveUser {
        func checkUserExists() {
            guard let userId = UserManager.shared.userId, userId.isEmpty == false else {
                return
            }

            let ref = Database.database().reference()

            ref.child("user/\(userId)").observeSingleEvent(of: .value, with: { [self] snapshot in
                if snapshot.exists() {
                    print("User exists")

                } else {
                }
            })
        }

        func saveUserFirebase() {
            let db = Firestore.firestore()
            let firstname = UserManager.shared.user?.givenName
            let lastname = UserManager.shared.user?.surname
            let email = UserManager.shared.user?.mail
            let phone = UserManager.shared.user?.mobilePhone
            let id = UserManager.shared.user?.id
            let role = UserManager.shared.user?.jobTitle

            guard let firstname = firstname, let lastname = lastname, let email = email, let phone = phone, let id = id, let role = role else {
                return
            }

            db.collection("user")
                .document(id)
                .setData(["id": id, "email": email, "first_name": firstname, "last_name": lastname, "role": role, "telephone": phone])
        }
    }
}
