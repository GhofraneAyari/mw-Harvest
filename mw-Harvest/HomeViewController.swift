//
//  HomeViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 29/03/2022.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var clockInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clockInButton.layer.cornerRadius = 50
        
        let gradient = CAGradientLayer()
        let lightGreen = hexStringToUIColor(hex: "#A9FFEA")
        let darkGreen = hexStringToUIColor(hex: "#00B288")
        gradient.colors = [lightGreen, darkGreen]
        gradient.frame = clockInButton.bounds
        clockInButton.layer.insertSublayer(gradient, at: 0)
    }
    
    
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


