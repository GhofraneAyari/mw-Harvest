//
//  SettingsViewController.swift
//  TimeTracker
//
//  Created by Francis Breidenbach on 7/14/17.
//  Copyright © 2017 Francis Breidenbach. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  // MARK: - Properties
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let existingUser = User.retrieve() {
      user = existingUser
    } else {
      presentLogin()
    }
  }
  
  
  // MARK: - Methods
  func presentLogin() {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    
    self.present(loginVC, animated: true)
    
  }
  
}
