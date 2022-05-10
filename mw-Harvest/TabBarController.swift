//
//  TabBarController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 04/05/2022.
//

import Foundation
import UIKit

final class TabBarController : UITabBarController {
    override func viewDidLoad() {
            super.viewDidLoad()
        if UserManager.shared.userId != "d1a43029-76df-4a0c-aa7c-5d864cea94fa" {
            
            viewControllers?.remove(at: 1) // remove the first tab, tab index starts with 0
            
        }
            
        }
}
