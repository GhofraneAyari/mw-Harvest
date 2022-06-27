//
//  UserService.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/05/2022.
//

import Firebase
import FirebaseDatabase
import Foundation
import SwiftKeychainWrapper

class UserService {
    static let instance = UserService()
    let db = Firestore.firestore()

    func getUserData(completion: (() -> Void)?) {
        let AccessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")

        var request = URLRequest(url: URL(string: Constants.profil.profilUrl)!)
        request.httpMethod = "GET"
        request.setValue(AccessToken, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, _: URLResponse?, error: Error?) in

            // TO LEARN
            guard let data = data else {
                return
            }

            if error != nil {
                print("error=\(String(describing: error))")
                return
            }

            let decoder = JSONDecoder()

            do {
                UserManager.shared.user = try decoder.decode(User.self, from: data)
            } catch {
                print("failed to convert\(error)")
            }
            completion?()
        }
        task.resume()
    }

    func checkUserExists() {
        guard let userId = UserManager.shared.userId, userId.isEmpty == false else {
            return
        }

        let docRef = db.collection("user").document(userId)
        docRef.getDocument { document, _ in
            if document!.exists {
                print("document exists")

            } else {
                print("document doesnt exist")

                self.db.collection("user")
                    .document(userId)
                    .setData(["id": userId, "email": UserManager.shared.user?.mail as Any, "first_name": UserManager.shared.user?.givenName as Any, "last_name": UserManager.shared.user?.surname as Any, "role": UserManager.shared.user?.jobTitle as Any, "telephone": UserManager.shared.user?.mobilePhone as Any])
            }
        }
    }
}
