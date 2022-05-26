//
//  InvoiceTableViewCell.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 05/04/2022.
//

import Foundation
import UIKit

class InvoiceTableViewCell: UITableViewCell {
    @IBOutlet var clientLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var paymentDateLabel: UILabel!
    @IBOutlet var warning: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Init code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(invoice: Invoice) {
        let amountStr: String = String(describing: invoice.amount)
        clientLabel.text = invoice.client
        amountLabel.text = "\("€") \(amountStr)"
        paymentDateLabel.text = "\("Due on") \(invoice.dueDate)"
    }
}
