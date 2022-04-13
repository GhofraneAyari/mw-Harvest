//
//  test.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 28/03/2022.
//

// ["id_token"]
import Foundation
import SwiftUI
import UIKit

class test: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let controller = UIHostingController(rootView: testView())
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)

        view.addConstraints([
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
        ])

//        NSLayoutConstraint.activate([
//            controller.view.widthAnchor.constraint(equalToConstant: 200),
//            controller.view.heightAnchor.constraint(equalToConstant: 44),
//            controller.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            controller.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//        ])
    }
}
