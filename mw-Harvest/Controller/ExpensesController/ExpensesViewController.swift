//
//  ExpensesViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/03/2022.
//

import Firebase
import FirebaseDatabase
import Foundation
import UIKit

class ExpensesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var invoiceVC: InvoiceViewController!
    @Published var invoices = [Invoice]()
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "InvoiceTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "invoiceCell")
        view.addSubview(tableView)

        var layoutGuide: UILayoutGuide!

        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true

        tableView.dataSource = self
        tableView.delegate = self

        getInvoiceData()
//        self.tableView.reloadData()

//        if InvoiceViewController().deleteButtonPressed == true {
//            self.tableView.reloadData()
//        }
    }

    @IBAction func segmentedChange(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
        } else if (sender as AnyObject).selectedSegmentIndex == 1 {
        }
    }

    func getInvoiceData() {
        let db = Firestore.firestore()

        db.collection("invoice").addSnapshotListener { snap, err in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            for i in snap!.documentChanges {
                let id = i.document.documentID
                let amount = i.document.get("amount") as! Double
                let client = i.document.get("client") as! String
                let creator = i.document.get("creator") as! String
                let dueDate = i.document.get("dueDate") as! String
                let issueDate = i.document.get("issueDate") as! String
                let isOpen = i.document.get("isOpen") as! Bool

                if i.type == .added {
                    print("Added")
                }
                if i.type == .modified {
                    print("Modified")
                }
                if i.type == .removed {
                    print("Removed")
                }

                self.tableView.reloadData()

                self.invoices.append(Invoice(id: id, amount: amount, client: client, creator: creator, dueDate: dueDate, issueDate: issueDate, isOpen: isOpen))
                if let row = self.invoices.count as? Any {
                    let indexPath = IndexPath(row: row as! Int - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if invoices.count == 0 {
            self.tableView.setEmptyMessage("No invoices at the moment.")
        } else {
            self.tableView.restore()
            
        }
        return invoices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath) as! InvoiceTableViewCell
        cell.set(invoice: invoices[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "invoiceInfo", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "invoiceInfo",
           let invoiceVC = segue.destination as? InvoiceViewController,
           let indexPath = sender as? IndexPath {
            let invoice = invoices[indexPath.row]
            invoiceVC.invoice = invoice
        }
    }
}


    extension UITableView {

        func setEmptyMessage(_ message: String) {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "Cairo", size: 22)
            messageLabel.sizeToFit()

            self.backgroundView = messageLabel
            self.separatorStyle = .none
        }

        func restore() {
            self.backgroundView = nil
            self.separatorStyle = .singleLine
        }
    }
