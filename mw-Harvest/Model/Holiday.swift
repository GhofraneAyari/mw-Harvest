//
//  Holiday.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 21/06/2022.
//

import Foundation

class Holiday {
    var id: String
    var leave_type : String
    var start_date: String
    var end_date: String
    var descriptin: String
    var is_approved: Bool
    var username : String
    var created_at: String
    
    init(id: String, leave_type: String, start_date: String, end_date: String, description: String, is_approved: Bool, username: String, created_at : String){
        
        self.id = id
        self.leave_type = leave_type
        self.start_date = start_date
        self.end_date = end_date
        self.descriptin = description
        self.is_approved = is_approved
        self.username = username
        self.created_at = created_at
        
    }
    
}
