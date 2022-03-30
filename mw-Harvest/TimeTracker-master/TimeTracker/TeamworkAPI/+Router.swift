//
//  +Router.swift
//  TimeTracker
//
//  Created by Francis Breidenbach on 7/15/17.
//  Copyright © 2017 Francis Breidenbach. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift


extension TeamworkAPI {
  
  enum Router: URLRequestConvertible {
    
    
    
    // MARK: - Cases
    case authenticate(String)
    
    
    
    // MARK: - URL Components
    
    /// Set base URL for the request. Authentication utilizes teamwork's generic auth endpoint.
    var baseURL: String {
      
      switch self {
      case .authenticate:
        return "https://authenticate.teamwork.com"
        
      }
      
    }
    
    
    /// Set request method: GET, PUT, POST, etc.
    var method: HTTPMethod {
      
      switch self {
        
      case .authenticate:
        return .get
        
      }
    }
    
    
    /// Path to append to baseURL. Must begin with "/".
    var relativePath: String {
      
      switch self {
        
      case .authenticate:
        return "/authenticate.json"
        
      }
      
    }
    
    
    /// Set request parameters.
    var parameters: Parameters? {
      
      switch self {
        
      case .authenticate:
        return nil
        
      }
      
    }
    
    
    /// Sets request headers. Default JSON headers are included without needing to be specified.
    var headers: [String: Any] {
      
      var headers = [String: Any]()
      
      headers["Content-Type"] = "application/json"
      headers["Accept"] = "application/json"
      
      switch self {
        
      case .authenticate(let key):
        do {
          let encodedKey = try TeamworkAPI.encode(apiKey: key)
          headers["Authorization"] = "Basic \(encodedKey)"
          return headers
        } catch let error {
          print(error.localizedDescription)
          return headers
        }
        
      }
    }
    
    
    
    func asURLRequest() throws -> URLRequest {
      
      guard let url = URL(string: baseURL) else {
        throw ServiceError.routingError(reason: "Error converting baseURL to URL")
      }
      
      let fullURL = url.appendingPathComponent(relativePath)
      
      var urlRequest = URLRequest(url: fullURL)
      urlRequest.httpMethod = method.rawValue
      
      for (key, value) in headers {
        urlRequest.setValue(value as? String, forHTTPHeaderField: key)
      }
      
      let encoding = URLEncoding.default
      
      return try encoding.encode(urlRequest, with: nil)
    }
    
  }
}


