//
//  InvoiceViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 05/04/2022.
//

import Firebase
import FirebaseDatabase
import Foundation
@testable import PDF_Generator
import PDFKit
import SwiftUI
import UIKit

class InvoiceViewController: UITableViewController {
    let documentInteractionController = UIDocumentInteractionController()
    var pdfObjects: [PDFObject] = []
    var expensesVC: ExpensesViewController!
    var invoice: Invoice?
    @Published var invoices = [Invoice]()

    @IBOutlet var toggleSwitch: UISwitch!
    @IBOutlet var creatorLabel: UILabel!
    @IBOutlet var clientLabel: UILabel!
    @IBOutlet var issueDateLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

//        print("im visible")

        if let invoice = invoice {
//            let amountStr : String = String (describing: invoice.amount)
            creatorLabel.text = invoice.creator
            clientLabel.text = invoice.client
            amountLabel.text = "\("€") \(invoice.amount)"
            dueDateLabel.text = "\("Due on") \(invoice.dueDate)"

            if invoice.isOpen == true {
                toggleSwitch.isOn = false
            }
//            else {
//                toggleSwitch.isOn = true
//            }
        }

//        if invoice?.isOpen == false {
//            toggleSwitch.setOn(true, animated: true)
//        }
    }

    @IBAction func deleteInvoiceButton(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Invoice", message: "Are you sure you want to delete this invoice?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
            print("Call the deletion function here")
            deleteRow(with: invoice!.id)
            invoices = invoices.filter { $0.id == invoice?.id }

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "deleteInvoice", sender: nil)
            }

        })
        alert.addAction(deleteAction)

//        dismiss(animated: true, completion: nil)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func deleteRow(with id: String) {
        let db = Firestore.firestore()

        db.collection("invoice").document(id).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

    @IBAction func toggleBuutton(_ sender: UISwitch) {
        let db = Firestore.firestore()
        let invoiceRef = db.collection("invoice").document(invoice!.id)

        if sender.isOn {
            invoiceRef.updateData(["isOpen": false]) { [self] error in
                if error == nil {
                    print("updated")

                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "deleteInvoice", sender: nil)
                        self.tableView.reloadData()
                    }

                } else {
                    print("not updated: \(String(describing: error))")
                }
            }
        }
    }

    @IBAction func generateInvoiceButtonPressed(_ sender: Any) {
        pdfHeader()
        pdfInvoiceTable()
        pdfFooter()

        let pdfCreator = PDFCreator(objects: pdfObjects)
        let pdfDocument = PDFDocument(data: pdfCreator.data)

        let fileName = "\("From") \(String(describing: invoice!.creator)) \("for") \(String(describing: invoice!.client))"
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("\(fileName)\(".pdf")")

        if let url = url {
            pdfDocument?.write(to: url)
        }

        documentInteractionController.delegate = self
        documentInteractionController.name = fileName
        documentInteractionController.url = url

        _ = documentInteractionController.presentPreview(animated: true)
    }

    func pdfHeader() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let currentDateString = dateFormatter.string(from: currentDate)

        let headerLabel = PDFLabel(text: "Invoice", rect: CGRect(x: 40, y: 40, width: 200, height: 20), attributes: PDFConstants.h1Attributes)

        pdfObjects.append(headerLabel)

        let subheaderLabel = PDFLabel(text: "\("Invoice created on") \(currentDateString)" as NSString, rect: CGRect(x: 40, y: 60, width: 200, height: 20), attributes: PDFConstants.h2Attributes)
        pdfObjects.append(subheaderLabel)
    }

    func pdfInvoiceTable() {
        let totalAmount: Float = Float(0.82 * invoice!.amount + invoice!.amount)
        let invoiceTable = PDFTable(items: [
            [
                PDFTableItem(header: "From", backgroundColor: .lightGray),
                PDFTableItem(header: "For", backgroundColor: .lightGray),
                PDFTableItem(header: "Issue date", backgroundColor: .lightGray),
                PDFTableItem(header: "Due date", backgroundColor: .lightGray),
                PDFTableItem(header: "Payment date", backgroundColor: .lightGray),
                PDFTableItem(header: "Amount", backgroundColor: .lightGray),

            ],

            [
                PDFTableItem(body: invoice!.creator),
                PDFTableItem(body: invoice!.client),
                PDFTableItem(body: invoice!.issueDate),
                PDFTableItem(body: invoice!.dueDate),
                PDFTableItem(body: invoice!.dueDate),
                PDFTableItem(body: "\("€") \(invoice!.amount)"),
            ], [],

            [
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
                PDFTableItem(header: "Subtotal"),
            ],

            [
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
                PDFTableItem(body: "\("€") \(invoice!.amount)"),
            ], [],

            [
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
                PDFTableItem(header: "Tax Rate"),
            ],
            [
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
                PDFTableItem(body: "18%"),
            ], [],
            [
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
                PDFTableItem(header: "Total"),
            ],
            [
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
//                PDFTableItem(body: ""),
                PDFTableItem(header: "\("€") \(totalAmount)"),
            ],
        ])
        pdfObjects.append(invoiceTable)
    }

    func pdfFooter() {
        let footerLabel = PDFLabel(text: "Date and client's signature", rect: CGRect(x: 440, y: 350, width: 400, height: 100), attributes: PDFConstants.cellHeaderAttributes)
        pdfObjects.append(footerLabel)
    }
}

extension InvoiceViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
