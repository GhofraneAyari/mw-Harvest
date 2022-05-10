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
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
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

    let profile = ProfileViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

//
//        leftLineView.layer.borderWidth = 1.0
//        leftLineView.layer.borderColor = UIColor.gray.cgColor
//        self.view.addSubview(leftLineView)
//
//        rightLineView.layer.borderWidth = 1.0
//        rightLineView.layer.borderColor = UIColor.gray.cgColor
//        self.view.addSubview(rightLineView)
//
//        orLabel.text = "or"
//        orLabel.font = UIFont(name: "Cairo-Regular", size: 20)
//        orLabel.textColor = UIColor(red: 187/256, green: 187/256, blue: 187/256, alpha: 1.0)
//        self.view.addSubview(orLabel)

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
            guard let self = self else { return }

            self.getUserData(completion: {
                self.checkUserExists()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Login", sender: nil)
                }
            }
            )

        })
    }

    func requestAccessToken(completion: (() -> Void)?) {
        let username = usernameTextField.text
        let password = passwordTextField.text

        var request = URLRequest(url: URL(string: Constants.LogInMicrosoft.microsoftUrl)!)
        request.httpMethod = "POST"
        let postString = "username=\(username!)&password=\(password!)&client_id=\(Constants.LogInMicrosoft.clientID)&scope=\(Constants.LogInMicrosoft.scope)&client_secret=\(Constants.LogInMicrosoft.clientSecret)&grant_type=\(Constants.LogInMicrosoft.grant_type)"

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

                    // print("Access token: \(String(describing: accessToken))")

                    //                    let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                    //                    let saveTokenID: Bool = KeychainWrapper.standard.set(tokenId != nil, forKey: "tokenId")
                    // acceessToken = ""
                    // accessToken = nil
                    if (accessToken?.isEmpty) != nil {
                        print("you are logged in")

                        let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                        let saveTokenID: Bool = KeychainWrapper.standard.set(tokenId != nil, forKey: "tokenId")

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

    func getUserData(completion: (() -> Void)?) {
        let AccessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")

        var request = URLRequest(url: URL(string: Constants.profil.profilUrl)!)
        request.httpMethod = "GET"
        request.setValue(AccessToken, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, _: URLResponse?, error: Error?) in

            // TO LEARN
            guard let data = data else {
                return
            }

            if error != nil {
                print("error=\(String(describing: error))")
                return
            }

            let decoder = JSONDecoder()

            do {
                UserManager.shared.user = try decoder.decode(User.self, from: data)
            } catch {
                print("failed to convert\(error)")
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

        /**
         Acquire a token for an existing account silently
         - forScopes: Permissions you want included in the access token received in the result in the completionBlock. Not all scopes are guaranteed to be included in the access token returned.
         - account: An account object that we retrieved from the application object before that the authentication flow will be locked down to.
         - completionBlock: The completion block that will be called when the authentication flow completes, or encounters an error.
         */

        let parameters = MSALSilentTokenParameters(scopes: kScopes, account: account)

        applicationContext.acquireTokenSilent(with: parameters) { result, error in

            if let error = error {
                let nsError = error as NSError
                // interactionRequired means we need to ask the user to sign-in. This usually happens
                // when the user's Refresh Token is expired or if the user has changed their password
                // among other possible reasons.

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

    //    func updateLogging(text : String) {
    //        if Thread.isMainThread {
    //            self.loggingText.text = text
    //        } else {
    //            DispatchQueue.main.async {
    //                self.loggingText.text = text
    //            }
    //        }
    //    }

    //    func updateAccountLabel() {
    //        guard let currentAccount = self.currentAccount else {
    //            self.usernameTextField.text = "Signed out"
    //            return
    //        }
    //
    //        self.usernameTextField.text = currentAccount.username
    //    }

    func updateCurrentAccount(account: MSALAccount?) {
        currentAccount = account
        // self.updateAccountLabel()
        // self.updateSignOutButton(enabled: account != nil)
    }

    //    @objc func getDeviceMode(_ sender: AnyObject) {
    //        if #available(iOS 13.0, *) {
    //            self.applicationContext?.getDeviceInformation(with: nil, completionBlock: { (deviceInformation, error) in
    //
    //                guard let deviceInfo = deviceInformation else {
    //                    print("Device info not returned. Error: \(String(describing: error))")
    //                    return
    //                }
    //
    //                let isSharedDevice = deviceInfo.deviceMode == .shared
    //                let modeString = isSharedDevice ? "shared" : "private"
    //                print("Received device info. Device is in the \(modeString) mode.")
    //            })
    //        } else {
    //            print("Running on older iOS. GetDeviceInformation API is unavailable.")
    //        }
    //    }

    @objc func initMSAL() throws {
        guard let authorityURL = URL(string: kAuthority) else {
            print("Unable to create authority URL")
            return
        }
        let authority = try MSALAADAuthority(url: authorityURL)
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: nil,
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
        let localAuthenticationContext = LAContext()
        var authorizationError: NSError?
        let reason = "Authentication required to login"
        let acceessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")

        if
            localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [self]
                success, evaluateError in
                if success && acceessToken != nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "Login", sender: nil)
                    }
                    print("You are now logged in")

                    //                    if successful, make segue to tabview

                } else {
                    guard let error = evaluateError else {
                        return
                    }
                    print(error)
                }
            }
        } else {
            guard let error = authorizationError else {
                return
            }
            print(error)
        }
    }

    func checkUserExists() {
        guard let userId = UserManager.shared.userId, userId.isEmpty == false else {
            return
        }

        let db = Firestore.firestore()
        let docRef = db.collection("user").document(userId)
        docRef.getDocument { document, _ in
            if document!.exists {
                print("document exists")

            } else {
                print("document doesnt exist")

                db.collection("user")
                    .document(userId)
                    .setData(["id": userId, "email": UserManager.shared.user?.mail as Any, "first_name": UserManager.shared.user?.givenName as Any, "last_name": UserManager.shared.user?.surname as Any, "role": UserManager.shared.user?.jobTitle as Any, "telephone": UserManager.shared.user?.mobilePhone as Any])
            }
        }
    }
    
    
}
