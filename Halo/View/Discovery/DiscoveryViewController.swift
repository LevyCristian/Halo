//
//  DiscoveryViewController.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import UIKit

class DiscoveryViewController: UIViewController {

    private lazy var discoveryView: DiscoveryView = {
        let view = DiscoveryView()
            .set(\.collectionView.delegate, to: self)
            .set(\.collectionView.dataSource, to: self)

        if let layout = view.collectionView.collectionViewLayout as? CardsFlowLayout {
            layout.delegate = self
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = discoveryView
    }

}

extension DiscoveryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DiscoveryCollectionViewCell.reuseIdentifier,
            for: indexPath) as? DiscoveryCollectionViewCell else {
            let cell = UICollectionViewCell()
            return cell
        }
        cell.titleLabel.text = "sadhiousdahadshasdasd"
        cell.imageView.backgroundColor = .gray
        return cell
    }
}

extension DiscoveryViewController: CardsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat.random(in: 100...250)
    }
}
