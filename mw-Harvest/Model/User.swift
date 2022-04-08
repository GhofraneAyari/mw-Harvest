//
//  User.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 22/03/2022.
//

import Foundation

struct User: Codable {
    let businessPhones: [String?]
    let displayName: String?
    let givenName: String?
    let jobTitle: String?
    let mail: String?
    let mobilePhone: String?
    let officeLocation: String?
    let preferredLanguage: String?
    let surname: String?
    let userPrincipalName: String?
    let id: String?
}

/*
 {
     "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users/$entity",
     "businessPhones": [],
     "displayName": "Ghofrane Ayari",
     "givenName": "Ghofrane",
     "jobTitle": null,
     "mail": "ghofrane.ayari@mobiweb.pt",
     "mobilePhone": null,
     "officeLocation": null,
     "preferredLanguage": null,
     "surname": "Ayari",
     "userPrincipalName": "ghofrane.ayari@mobiweb.pt",
     "id": "d1a43029-76df-4a0c-aa7c-5d864cea94fa"
 }
 */
