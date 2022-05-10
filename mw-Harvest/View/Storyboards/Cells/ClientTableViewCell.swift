//
//  ClientTableViewCell.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 27/04/2022.
//

import Foundation
import UIKit

class ClientTableViewCell: UITableViewCell {
    @IBOutlet var clientNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Init code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(client: Client) {
        clientNameLabel.text = client.name
        addressLabel.text = client.address
    }
}
