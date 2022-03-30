//
//  User.swift
//  TimeTracker
//
//  Created by Francis Breidenbach on 7/14/17.
//  Copyright © 2017 Francis Breidenbach. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


class User: Object {
  
  // MARK: - Properties
  dynamic var firstName = ""
  dynamic var lastName = ""
  dynamic var id = 0
  dynamic var isAdmin = false
  dynamic var url = "https://authenticate.teamwork.com"
  dynamic var hasAuthenticated = false
  dynamic var apiKey = "None"
  dynamic var legit = ""
  
  
  // MARK: - Init
  convenience init(fromJSON json: JSON) {
    self.init()
    
    let userID = json["userId"].stringValue
    guard let numberID = Int(userID) else { return }
    
    id = numberID
    firstName = json["firstname"].stringValue
    lastName = json["lastname"].stringValue
    isAdmin = json["userIsAdmin"].boolValue
    url = json["URL"].stringValue
    
    hasAuthenticated = true
    
    legit = "yes"
  }
  
  convenience init(creatEmpty legit: String) {
    self.init()
    
    self.legit = legit
  }
  
  
  // MARK: - Realm
  override static func primaryKey() -> String? {
    return "legit"
  }
  
  
  
  // MARK: - Methods
  static func retrieve() -> User? {
    let realm = try! Realm()
    
    return realm.object(ofType: User.self, forPrimaryKey: "yes")
  }
  
  
  // MARK: - Helpers
  static let empty = User(creatEmpty: "no")
  
}








