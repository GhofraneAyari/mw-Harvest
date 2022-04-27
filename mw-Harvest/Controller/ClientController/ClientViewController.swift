//
//  ClientViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 27/04/2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class ClientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @Published var clients = [Client]()
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "ClientTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "clientCell")
        view.addSubview(tableview)
        
        tableview.dataSource = self
        tableview.delegate = self
        
        getClientData()
    }
    
    func getClientData() {
        let db = Firestore.firestore()

        db.collection("client").addSnapshotListener { [self] snap, err in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            for i in snap!.documentChanges {
                let id = i.document.documentID
                let name = i.document.get("name") as! String
                let address = i.document.get("address") as! String
                let currency = i.document.get("currency") as! String
                let created_at = i.document.get("created_at") as! String
                

               

                

                self.clients.append(Client(id: id, name: name, address: address, currency: currency, created_at: created_at))
//                if let row = self.invoices.count as? Any {
////                    let indexPath = IndexPath(row: row as! Int - 1, section: 0)
////                    self.tableView.insertRows(at: [indexPath], with: .automatic)
//                }
            }
            self.tableview.reloadData()
            
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientCell", for: indexPath) as! ClientTableViewCell
        cell.set(client: clients[indexPath.row])
        return cell
    }
    
    
}
