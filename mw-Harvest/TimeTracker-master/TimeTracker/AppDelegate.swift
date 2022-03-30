//
//  AppDelegate.swift
//  TimeTracker
//
//  Created by Francis Breidenbach on 7/14/17.
//  Copyright (c) 2017 Francis Breidenbach. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    guard let tabController = window?.rootViewController as? UITabBarController else { return true }
    
    tabController.selectedIndex = 2
    
    return true
    
  }
}
