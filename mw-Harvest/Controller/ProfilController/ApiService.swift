//
//  ApiService.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 22/03/2022.
//

import Foundation
import SwiftKeychainWrapper

class ApiService {
    func getUserData(completion: @escaping (Result<User, Error>) -> Void) {
        let AccessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")

        var request = URLRequest(url: URL(string: "https://graph.microsoft.com/v1.0/me")!)
        request.httpMethod = "GET"
        request.setValue(AccessToken, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [self] (data: Data?, _: URLResponse?, error: Error?) in

            if error != nil {
                print("error=\(String(describing: error))")
                return
            }

            var result: User?
            let decoder = JSONDecoder()

            do {
                result = try decoder.decode(User.self, from: data!)
            } catch {
                print("failed to convert\(error)")
            }

            guard let json = result else {
                return
            }

            print(json.displayName as Any)
            print(json.givenName as Any)
            print(json)

        }; task.resume()
    }
}
