//
//  MoreCollectionViewCell.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 16/03/2022.
//

import Foundation
import UIKit

class MoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var actionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        clipsToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 2.0)
        layer.shadowRadius = 2.5
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }

    func updateShadow() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
