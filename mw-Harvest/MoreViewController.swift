//
//  MoreViewController.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 16/03/2022.
//

import Foundation
import UIKit

class MoreViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var holidayListButton: UIBarButtonItem!

    final var moreActionLabels = ["Submit timesheet",
                                  "Request holiday",
                                  "Manage clients",
                                  "Contact admin",
                                  "Dark mode",
                                  "About"]

    final var imageStrings = ["submit",
                              "holiday",
                              "clients",
                              "contact",
                              "nightMode",
                              "about"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        if UserManager.shared.userId != "d1a43029-76df-4a0c-aa7c-5d864cea94fa" {
            holidayListButton?.isEnabled = false
            holidayListButton?.tintColor = UIColor.clear
        }
    }
}

extension MoreViewController {
    func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width / 2 - 17, height: collectionView.frame.width / 2 - 17)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout

        let nib = UINib(nibName: "MoreCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MoreCollectionViewCell")
    }
}

extension MoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreActionLabels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCollectionViewCell", for: indexPath) as! MoreCollectionViewCell

        cell.actionLabel.text = moreActionLabels[indexPath.row]
        cell.imageIcon.image = UIImage(named: imageStrings[indexPath.row]) ?? UIImage()
        cell.updateShadow()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.windows.first

        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "submit", sender: indexPath)
        case 1:
            performSegue(withIdentifier: "holiday", sender: indexPath)
        case 2:
            performSegue(withIdentifier: "clients", sender: indexPath)
        case 3:
            performSegue(withIdentifier: "contactAdmin", sender: indexPath)
        case 4:
            if #available(iOS 13.0, *) {
                if appDelegate?.overrideUserInterfaceStyle == .light {
                    appDelegate?.overrideUserInterfaceStyle = .dark
                } else {
                    appDelegate?.overrideUserInterfaceStyle = .light
                }
            }

        case 5:
            performSegue(withIdentifier: "about", sender: indexPath)

        default:
            print("Could not find indexpath")
        }
    }
}
