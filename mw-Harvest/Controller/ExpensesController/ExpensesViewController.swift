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
    @IBOutlet var segmentedControl: UISegmentedControl!

    var invoice: Invoice?
    var invoiceVC: InvoiceViewController!
    @Published var invoices = [Invoice]()
    let user = UserManager.shared.user

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.setEmptyMessage("No invoices at the moment.")

        let cellNib = UINib(nibName: "InvoiceTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "invoiceCell")
        view.addSubview(tableView)

//        var layoutGuide: UILayoutGuide!

//        if #available(iOS 11.0, *) {
//            layoutGuide = view.safeAreaLayoutGuide
//        } else {
//            // Fallback on earlier versions
//            layoutGuide = view.layoutMarginsGuide
//        }

//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true

        tableView.dataSource = self
        tableView.delegate = self

        getInvoiceData()
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

                // TODO: fix this
                guard let isOpen = i.document.get("isOpen") as? Bool else {
                    return
                }

                if i.type == .added {
                    print("Added")
                    self.invoices.append(Invoice(id: id, amount: amount, client: client, creator: creator, dueDate: dueDate, issueDate: issueDate, isOpen: isOpen))
                }
                if i.type == .modified {
                    print("Modified")
                }
                if i.type == .removed {
                    print("Removed")
                    self.invoices = self.invoices.compactMap({ invoice in
                        invoice.id == id ? nil : invoice
                    })
                }

//                if let row = self.invoices.count as? Any {
                ////                    let indexPath = IndexPath(row: row as! Int - 1, section: 0)
                ////                    self.tableView.insertRows(at: [indexPath], with: .automatic)
//                }
            }
            self.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let openInvoice = invoices.filter { $0.isOpen == true }
        let closedInvoice = invoices.filter { $0.isOpen == false }
        tableView.backgroundView?.isHidden = !invoices.isEmpty
        if invoices.isEmpty == false {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                return openInvoice.count
            case 1:
                return closedInvoice.count
            default:
                break
            }
//            self.tableView.restore()
        }
//        return invoices.count
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath) as! InvoiceTableViewCell
        let openInvoice = invoices.filter { $0.isOpen == true }
        let closedInvoice = invoices.filter { $0.isOpen == false }
        switch segmentedControl.selectedSegmentIndex {
        case 0:

            cell.set(invoice: openInvoice[indexPath.row])

        case 1:
            cell.set(invoice: closedInvoice[indexPath.row])
        default:
            break
        }
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

    @IBAction func segmentedChange(_ sender: Any) {
        tableView.reloadData()
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let aColor = UIColor(named: "color1")
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = aColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Cairo", size: 22)
        messageLabel.sizeToFit()

        backgroundView = messageLabel
        separatorStyle = .none
    }

    func restore() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
}
