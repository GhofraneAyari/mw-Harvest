//
//  Invoice.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 04/04/2022.
//

import Foundation

class Invoice {
    var id: String
    var amount: Double
    var client: String
    var creator: String
    var dueDate: String
    var issueDate: String
    var isOpen : Bool

    init(id: String, amount: Double, client: String, creator: String, dueDate: String, issueDate: String, isOpen : Bool) {
        self.id = id
        self.amount = amount
        self.client = client
        self.creator = creator
        self.dueDate = dueDate
        self.issueDate = issueDate
        self.isOpen = isOpen
    }
}
