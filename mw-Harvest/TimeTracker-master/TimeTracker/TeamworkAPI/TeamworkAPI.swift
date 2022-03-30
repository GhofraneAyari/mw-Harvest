//
//  TeamworkAPI.swift
//  TimeTracker
//
//  Created by Francis Breidenbach on 7/14/17.
//  Copyright © 2017 Francis Breidenbach. All rights reserved.
//

import Foundation
import Alamofire



class TeamworkAPI {
  
  static let sharedInstance = TeamworkAPI()
  
  private init() {}
  
  
  // MARK: - Class Functions
  class func encode(apiKey key: String) throws -> String {
    
    guard key.characters.count > 0 else {
      throw ServiceError.keyEncoderError(reason: "Cannot encode an empty key")
    }
    
    let keyWithPassword = key.appending(":fuckthisjob")
    
    var encodedResult: String
    let keyAsData = keyWithPassword.data(using: .utf8)
    
    if let encodedKey = keyAsData?.base64EncodedString() {
      encodedResult = encodedKey
      return encodedResult
    } else {
      
      throw ServiceError.keyEncoderError(reason: "Failed to encode key data as base 64 string")
      
    }
  }
  
}


// MARK: - Error
extension TeamworkAPI {
  
  enum ServiceError: Error {
    
    case routingError(reason: String)
    case keyEncoderError(reason: String)
    
  }
  
}
