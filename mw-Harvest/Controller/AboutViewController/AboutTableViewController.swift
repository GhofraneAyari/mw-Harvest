//
//  AboutTableViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 03/05/2022.
//

import Foundation
import UIKit

class AboutTableViewController: UITableViewController {
    @IBOutlet var udidLabel: UILabel!
    @IBOutlet var deviceNameLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var osLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let udid = UIDevice.current.identifierForVendor?.uuidString
        let name = UIDevice.current.name
        let version = UIDevice.current.systemVersion
        let modelName = UIDevice.current.model
        let osName = UIDevice.current.systemName

        udidLabel.text = udid
        deviceNameLabel.text = name
        versionLabel.text = version
        modelLabel.text = modelName
        osLabel.text = osName
    }
}
