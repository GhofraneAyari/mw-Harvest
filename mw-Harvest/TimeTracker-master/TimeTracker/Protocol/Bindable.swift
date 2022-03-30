//
//  Bindable.swift
//  TimeTracker
//
//  Created by Francis Breidenbach on 7/14/17.
//  Copyright © 2017 Francis Breidenbach. All rights reserved.
//

import UIKit
import RxSwift


protocol Bindable {
  
  associatedtype ViewModelType
  
  var viewModel: ViewModelType { get set }
  
  func bindViewModel()
  
}


extension Bindable where Self: UIViewController {
  
  mutating func bindViewModel(using model: Self.ViewModelType) {
    self.viewModel = model
    loadViewIfNeeded()
    bindViewModel()
  }
  
}
