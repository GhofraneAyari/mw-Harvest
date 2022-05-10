//
//  Project.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 10/05/2022.
//

import Foundation

class Project {
    var id: String
    var name: String
    var userId: String
   

    init(id: String, name: String, userId: String) {
        self.id = id
        self.name = name
        self.userId = userId
        
    }
}
