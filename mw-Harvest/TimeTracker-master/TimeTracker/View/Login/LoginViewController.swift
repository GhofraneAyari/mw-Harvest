//
//  LoginViewController.swift
//  TimeTracker
//
//  Created by Francis Breidenbach on 7/15/17.
//  Copyright © 2017 Francis Breidenbach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class LoginViewController: UIViewController {
  
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var keyTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  let authenticationManager = AuthenticationManager()
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let status = authenticationManager.status.asDriver()
    
    status
      .drive(statusLabel.rx.text)
      .disposed(by: disposeBag)
    
    let authRequest = loginButton.rx.tap.asObservable()
      .withLatestFrom(keyTextField.rx.text)
      .filter { ($0 ?? "").characters.count > 0 }
      .flatMap { key in
        return self.authenticationManager.authorizationRequest(withKey: key ?? "Error")
          .catchErrorJustReturn(User.empty)
    }
    
    
    authRequest
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { user in
        self.authenticationManager.status.value = "User authenticated? \(user.hasAuthenticated)"
      }, onError: { _ in
        self.authenticationManager.status.value = "Error occurred during authentication"
      })
      .disposed(by: disposeBag)
    
  }
  
}
