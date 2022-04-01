//
//  ExpensesViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/03/2022.
//

import Foundation
import UIKit

class ExpensesViewController: UIViewController{
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    //segment dummy data
    let open = ["Vodafone", "Sky", "Sky", "CellFocus", "STC"]
    let closed = ["Vodafone", "Sky", "Sky", "CellFocus", "STC", "Cellfocus", "Momenti"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func segmentedChange(_ sender: Any) {
    }
}



