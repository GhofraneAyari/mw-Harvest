//
//  Constants.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 15/03/2022.
//

struct Constants {
    
    struct LogInMicrosoft {
        static let microsoftUrl = "https://login.microsoftonline.com/organizations/oauth2/v2.0/token"
//        static let clientID = "8e621366-7406-4c69-8659-cfc6add5295d"
        static let clientID = "3d270ff3-f0f1-41ff-90a8-df93b0be47c1"
        
//        static let clientSecret = "mJt7Q~SAt1D2DDhn9GmK4MjBQK9xwrCqK8se."
        static let clientSecret = "hcK7Q~lPNAS-mPO~Z3IBcswmumaxeGsujIL_I"
        static let kGraphEndpoint = "https://graph.microsoft.com/"
        static let kAuthority = "https://login.microsoftonline.com/common"
        static let scope = "user.read openid profile offline_access"
        static let grant_type = "password"
        
        
        
    }
}
