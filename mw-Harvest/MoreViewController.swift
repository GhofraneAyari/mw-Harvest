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

    final var homeActionLabels = ["Create a new invoice",
                                  "Edit information",
                                  "Manage clients",
                                  "View saved items",
                                  "View previous invoices",
                                  "Settings"]

    final var imageStrings = ["plus",
                              "curUserImage",
                              "clientsImage",
                              "viewSavedItemsImage",
                              "previousInvoicesImage",
                              "settingsImage"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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
        return homeActionLabels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCollectionViewCell", for: indexPath) as! MoreCollectionViewCell

        cell.actionLabel.text = homeActionLabels[indexPath.row]
        cell.imageIcon.image = UIImage(named: imageStrings[indexPath.row]) ?? UIImage()
        cell.updateShadow()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "newInvoiceVC")
            vc.modalPresentationStyle = .overFullScreen

            present(vc, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "CurUserInformation", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "editInfoVC")
            vc.modalPresentationStyle = .popover

            present(vc, animated: true)
        case 2:
            let storyboard = UIStoryboard(name: "Clients", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "clientsVC")
            vc.modalPresentationStyle = .popover

            present(vc, animated: true)
        case 3:
            let storyboard = UIStoryboard(name: "Items", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "itemsVC")
            vc.modalPresentationStyle = .popover

            present(vc, animated: true)
        case 4:
            let storyboard = UIStoryboard(name: "PreviousInvoices", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "previousInvoicesVC")
            vc.modalPresentationStyle = .overFullScreen

            present(vc, animated: true)
        case 5:
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "settingsVC")
            vc.modalPresentationStyle = .popover

            present(vc, animated: true)
        default:
            print("Could not find indexpath")
        }
    }
}
