//
//  ClientInfoViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 02/05/2022.
//

import Firebase
import FirebaseDatabase
import Foundation
import UIKit

class ClientInfoViewController: UITableViewController {
    var client: Client?
    @IBOutlet var clientName: UILabel!
    @IBOutlet var clientAddress: UILabel!
    @IBOutlet var currency: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var deleteClientButton: UIButton!
    @IBOutlet var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserManager.shared.userId != "d1a43029-76df-4a0c-aa7c-5d864cea94fa" {
            deleteClientButton.isHidden = true
        }

        if let client = client {
            clientName.text = client.name
            clientAddress.text = client.address
            currency.text = client.currency
            createdAtLabel.text = client.created_at
        }
    }

    @IBAction func deleteClientButton(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Client", message: "Are you sure you want to delete this client?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
            print("Call the deletion function here")
            deleteClient(with: client!.id)

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "deleteClient", sender: nil)
            }

        })
        alert.addAction(deleteAction)

//        dismiss(animated: true, completion: nil)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func deleteClient(with id: String) {
        let db = Firestore.firestore()

        db.collection("client").document(id).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if UserManager.shared.userId != "d1a43029-76df-4a0c-aa7c-5d864cea94fa" {
                return 0.0
            }
        }
        return UITableView.automaticDimension
    }
}
