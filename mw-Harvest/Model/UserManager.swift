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

    
}
