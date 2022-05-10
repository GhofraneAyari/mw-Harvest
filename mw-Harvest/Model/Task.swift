//
//  Task.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 09/05/2022.
//

import Foundation

class Task {
    var id: String
    var name: String
    var userId: String
   

    init(id: String, name: String, userId: String) {
        self.id = id
        self.name = name
        self.userId = userId
        
    }
}
