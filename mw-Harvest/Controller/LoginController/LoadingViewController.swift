//
//  LoadingViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/05/2022.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Login", sender: nil)
        }
    }
}
