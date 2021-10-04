//
//  DiscoveryView.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import UIKit

class DiscoveryView: UIView {

    lazy var collectionView: UICollectionView = {
        let layout = CardsFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(DiscoveryCollectionViewCell.self,
                                forCellWithReuseIdentifier: DiscoveryCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
}

extension DiscoveryView: ViewCode {
    func buildViewHierarchy() {
        addSubview(collectionView)
    }

    func setupConstraints() {
        collectionView
            .anchor(\.topAnchor,
                     referentTo: self,
                     equal: \.topAnchor,
                     constant: 12)
            .anchor(\.leadingAnchor,
                     referentTo: self,
                     equal: \.leadingAnchor)
            .anchor(\.trailingAnchor,
                     referentTo: self,
                     equal: \.trailingAnchor)
            .anchor(\.bottomAnchor,
                     referentTo: self,
                     equal: \.bottomAnchor)
    }

    func setupAdditionalConfigurantion() {
        self.backgroundColor = .black
    }
}
