//
//  EventTableViewCell.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 19/04/2022.
//

import Foundation
import UIKit

class EventTableViewCell : UITableViewCell {
    
//    @IBOutlet weak var client: UILabel!
    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var time: UILabel!
//    @IBOutlet weak var project: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Init code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(event: Event) {
//        client.text = event.client
//        project.text = event.project
        task.text = event.task
        time.text = event.time
    }
    
}
