//
//  ClientViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 27/04/2022.
//

import Firebase
import FirebaseDatabase
import Foundation
import UIKit

class ClientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @Published var clients = [Client]()
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.target = self
        addButton.action = #selector(addButtonClicked)

        let cellNib = UINib(nibName: "ClientTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "clientCell")

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
//                let address = i.document.get("address") as! String
                let currency = i.document.get("currency") as! String
                let created_at = i.document.get("created_at") as! String

                guard let address = i.document.get("address") as? String else {
                    return
                }

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "clientInfo", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clientInfo",
           let clientVC = segue.destination as? ClientInfoViewController,
           let indexPath = sender as? IndexPath {
            let client = clients[indexPath.row]
            clientVC.client = client
        }
    }
    
    @objc func addButtonClicked(sender: UIBarButtonItem) {
        if UserManager.shared.userId != "d1a43029-76df-4a0c-aa7c-5d864cea94fa" {
            print("Admin only")
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Admin only feature", message: "You have to be admin to access this feature", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                return
            }
        }else {
            performSegue(withIdentifier: "newClient", sender: self) 
            
        }
    }
    
    
    
    
}
