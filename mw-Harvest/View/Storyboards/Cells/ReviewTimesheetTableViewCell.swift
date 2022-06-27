//
//  ReviewTimesheetTableViewCell.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 17/05/2022.
//

import Foundation
import UIKit

class ReviewTimesheetTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var company: UILabel!
    @IBOutlet var project: UILabel!
    @IBOutlet var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Init code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(event: Event) {
        name.text = UserManager.shared.user?.displayName
        company.text = event.client
        project.text = event.project
        time.text = event.time
    }
}
