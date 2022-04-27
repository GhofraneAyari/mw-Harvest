//
//  Client.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 27/04/2022.
//

import Foundation

class Client {
    var id: String
    var name: String
    var address: String
    var currency : String
    var created_at: String
   

    init(id: String, name: String, address: String, currency: String, created_at: String) {
        self.id = id
        self.name = name
        self.address = address
        self.currency = currency
        self.created_at = created_at
    }
}
