//
//  DiscoveryCollectionViewCell.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import UIKit

class DiscoveryCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
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

extension DiscoveryCollectionViewCell: ViewCode {
    func buildViewHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
    }

    func setupConstraints() {
        imageView
            .anchor(\.topAnchor, referentTo: self, equal: \.topAnchor)
            .anchor(\.leadingAnchor, referentTo: self, equal: \.leadingAnchor)
            .anchor(\.trailingAnchor, referentTo: self, equal: \.trailingAnchor)

        titleLabel
            .anchor(\.topAnchor, referentTo: imageView, equal: \.bottomAnchor)
            .anchor(\.leadingAnchor, referentTo: self, equal: \.leadingAnchor)
            .anchor(\.trailingAnchor, referentTo: self, equal: \.trailingAnchor)
            .anchor(\.bottomAnchor, referentTo: self, equal: \.bottomAnchor)

    }
}
