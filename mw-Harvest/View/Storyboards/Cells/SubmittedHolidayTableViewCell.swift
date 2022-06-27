//
//  SubmittedHolidayTableViewCell.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 21/06/2022.
//

import Foundation
import UIKit

class SubmittedHolidayTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var leaveType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Init code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(holiday: Holiday) {
        name.text = holiday.username
        leaveType.text = holiday.leave_type
    }
}
