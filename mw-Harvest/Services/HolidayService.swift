//
//  HolidayService.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/05/2022.
//

import Firebase
import FirebaseDatabase
import Foundation

class HolidayService {
    static let instance = HolidayService()
    let db = Firestore.firestore()

    func addHolidayInfo(userId: String, username: String, leave_type: String, start_date: String, end_date: String, description: String, is_approved: Bool) {
        db.collection("holidayRequests")
            .document()
            .setData(["userId": userId, "username": username, "leave_type": leave_type, "start_date": start_date, "end_date": end_date, "description": description, "is_approved": is_approved])
    }
}
