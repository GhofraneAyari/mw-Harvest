//
//  LoginViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 14/03/2022.
//

import Firebase
import FirebaseDatabase
import Foundation
import LocalAuthentication
import MSAL
import SwiftKeychainWrapper
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var microsoftLoginButton: UIButton!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var forgotPasswordButton: UIButton!

    // Update the below to your client ID you received in the portal. The below is for running the demo only
    let kClientID = Constants.LogInMicrosoft.clientID
    let kGraphEndpoint = Constants.LogInMicrosoft.kGraphEndpoint // the Microsoft Graph endpoint
    let kAuthority = Constants.LogInMicrosoft.kAuthority // this authority allows a personal Microsoft account and a work or school account in any organization's Azure AD tenant to sign in

    let kScopes: [String] = ["user.read"] // request permission to read the profile of the signed-in user

    var accessToken = String()
    var applicationContext: MSALPublicClientApplication?
    var webViewParameters: MSALWebviewParameters?
    var currentAccount: MSALAccount?

    var leftLineView = UIView(frame: CGRect(x: 32, y: 343, width: 130, height: 1.0))
    var rightLineView = UIView(frame: CGRect(x: 250, y: 343, width: 130, height: 1.0))
    let orLabel = UILabel(frame: CGRect(x: 198, y: 325, width: 18, height: 30))
    

    override func viewDidLoad() {
        super.viewDidLoad()

        microsoftLoginButton.addTarget(self, action: #selector(callGraphAPI), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(callGraphAPI), for: .touchUpInside)

        do {
            try initMSAL()
        } catch let error {
            print("Unable to create Application Context \(error)")
        }

        loadCurrentAccount()
        platformViewDidLoadSetup()
    }

    @IBAction func LoginButtonPressed(_ sender: Any) {
        print("sign in button tapped")

        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }

        if username.isEmpty || password.isEmpty {
            print("Username or password fields are empty")
            DispatchQueue.main.async {
                print("incorrect - try again")
                let alert = UIAlertController(title: "Try Again", message: "Username or password fields are empty", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                return
            }
        }

        requestAccessToken(completion: { [weak self] in
            guard self != nil else { return }

            UserService.instance.getUserData(completion: {
                UserService.instance.checkUserExists()

//                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "Login", sender: nil)
//                }
            }
            )

        })
    }

    func requestAccessToken(completion: (() -> Void)?) {
        let username = usernameTextField.text
        let password = passwordTextField.text

//        let username = "marcio.martins@mobiweb.pt"
//        let password = "Marcio202204"

        var request = URLRequest(url: URL(string: Constants.LogInMicrosoft.microsoftUrl)!)
        request.httpMethod = "POST"
        let postString = "username=\(username!)&password=\(password!)&client_id=\(Constants.LogInMicrosoft.clientID)&scope=\(Constants.LogInMicrosoft.scope)&client_secret=\(Constants.LogInMicrosoft.clientSecret)&grant_type=\(Constants.LogInMicrosoft.grant_type)"

//        let postString = "username=\(username)&password=\(password)&client_id=\(Constants.LogInMicrosoft.clientID)&scope=\(Constants.LogInMicrosoft.scope)&client_secret=\(Constants.LogInMicrosoft.clientSecret)&grant_type=\(Constants.LogInMicrosoft.grant_type)"

        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data: Data?, _: URLResponse?, error: Error?) in

            guard let self = self, let data = data else {
                return
            }

            if error != nil {
                print("error=\(String(describing: error))")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary

                if let parseJSON = json {
                    let accessToken = parseJSON["access_token"] as? String
                    let tokenId = parseJSON["id_token"] as? String
                    if (accessToken?.isEmpty) != nil {
                        print("you are logged in")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.performSegue(withIdentifier: "loading", sender: nil)
                        }

                        let _: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                        let _: Bool = KeychainWrapper.standard.set(tokenId != nil, forKey: "tokenId")

                    } else {
                        print("could not perform request")
                        DispatchQueue.main.async {
                            print("incorrect - try again")
                            let alert = UIAlertController(title: "Try Again", message: "Incorrect Username or Password", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }

            } catch {
                print(error)
            }

            completion?()
        }
        task.resume()
    }
    
    

    func getGraphEndpoint() -> String {
        return kGraphEndpoint.hasSuffix("/") ? (kGraphEndpoint + "v1.0/me/") : (kGraphEndpoint + "/v1.0/me/")
    }

    @objc func callGraphAPI() {
        loadCurrentAccount { account in
            guard let currentAccount = account else {
                // We check to see if we have a current logged in account.
                // If we don't, then we need to sign someone in.
                self.acquireTokenInteractively()
                return
            }
            self.acquireTokenSilently(currentAccount)
        }
    }

    typealias AccountCompletion = (MSALAccount?) -> Void

    func loadCurrentAccount(completion: AccountCompletion? = nil) {
        guard let applicationContext = self.applicationContext else { return }

        let msalParameters = MSALParameters()
        msalParameters.completionBlockQueue = DispatchQueue.main

        applicationContext.getCurrentAccount(with: msalParameters, completionBlock: { currentAccount, _, error in
            if let error = error {
                print("Couldn't query current account with error: \(error)")
                return
            }
            if let currentAccount = currentAccount {
                print("Found a signed in account \(String(describing: currentAccount.username)). Updating data for that account...")
                self.updateCurrentAccount(account: currentAccount)

                if let completion = completion {
                    completion(self.currentAccount)
                }
                return
            }

            print("Account signed out. Updating UX")
            self.accessToken = ""
            self.updateCurrentAccount(account: nil)

            if let completion = completion {
                completion(nil)
            }
        })
    }

    func acquireTokenInteractively() {
        guard let applicationContext = self.applicationContext else { return }
        guard let webViewParameters = self.webViewParameters else { return }

        // #1
        let parameters = MSALInteractiveTokenParameters(scopes: kScopes, webviewParameters: webViewParameters)
        parameters.promptType = .selectAccount

        // #2
        applicationContext.acquireToken(with: parameters) { result, error in

            // #3
            if let error = error {
                print("Could not acquire token: \(error)")
                return
            }

            guard let result = result else {
                print("Could not acquire token: No result returned")
                return
            }

            // #4
            self.accessToken = result.accessToken
            // self.updateLogging(text: "Access token is \(self.accessToken)")
            self.updateCurrentAccount(account: result.account)
            self.getContentWithToken()
        }
    }

    func platformViewDidLoadSetup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appCameToForeGround(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    func acquireTokenSilently(_ account: MSALAccount!) {
        guard let applicationContext = self.applicationContext else { return }

        let parameters = MSALSilentTokenParameters(scopes: kScopes, account: account)

        applicationContext.acquireTokenSilent(with: parameters) { result, error in

            if let error = error {
                let nsError = error as NSError

                if nsError.domain == MSALErrorDomain {
                    if nsError.code == MSALError.interactionRequired.rawValue {
                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }
                print("Could not acquire token silently: \(error)")
                return
            }

            guard let result = result else {
                print("Could not acquire token: No result returned")
                return
            }

            self.accessToken = result.accessToken
            // self.updateLogging(text: "Refreshed Access token is \(self.accessToken)")
            // self.updateSignOutButton(enabled: true)
            self.getContentWithToken()
        }
    }

    func getContentWithToken() {
        // Specify the Graph API endpoint
        let graphURI = getGraphEndpoint()
        let url = URL(string: graphURI)
        var request = URLRequest(url: url!)

        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                print("Couldn't get graph result: \(error)")
                return
            }

            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                print("Couldn't deserialize result JSON")
                return
            }

            print("Result from Graph: \(result))")

        }.resume()
    }

    func updateCurrentAccount(account: MSALAccount?) {
        currentAccount = account
    }

    @objc func initMSAL() throws {
        guard let authorityURL = URL(string: kAuthority) else {
            print("Unable to create authority URL")
            return
        }
        let authority = try MSALAADAuthority(url: authorityURL)
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: "msauth.com.mw-Harvest://auth",
                                                                  authority: authority)
        applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
        initWebViewParams()
    }

    func initWebViewParams() {
        webViewParameters = MSALWebviewParameters(authPresentationViewController: self)
    }

    @objc func appCameToForeGround(notification: Notification) {
        loadCurrentAccount()
    }

    @IBAction func touchIdButtonPressed(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authorize with Face ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in

                if success {
                    print("You are logged in")
                }

                DispatchQueue.main.async {
                    guard success, error == nil else {
                        // failed

                        let alert = UIAlertController(title: "Failed to Authenticate", message: "Please try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self!.present(alert, animated: true)

                        return
                    }
                }

                DispatchQueue.main.async {
                    self!.performSegue(withIdentifier: "Login", sender: nil)
                }

                // Show other screen
                // Suceess
            }
        } else {
            // Cant use
            let alert = UIAlertController(title: "Unavailable", message: "You can't' use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    @IBAction func hidePassword(_ sender: Any) {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
        }else {
            passwordTextField.isSecureTextEntry = true
        }
        
    }
}
