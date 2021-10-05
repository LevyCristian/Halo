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
            .set(\.contentMode, to: .scaleAspectFill)
            .set(\.clipsToBounds, to: true)
            .set(\.layer.cornerRadius, to: 15)
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

    func configureCard(showTitle: String) {
        titleLabel
            .set(\.text, to: showTitle)
            .set(\.textColor, to: .white)
            .set(\.font, to: UIFont.systemFont(ofSize: 17, weight: .semibold))
    }

    func loadCardImage(from data: Data) {
        let image = UIImage(data: data)
        imageView
            .set(\.image, to: image)
    }

    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
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
            .anchor(\.topAnchor, referentTo: imageView, equal: \.bottomAnchor, constant: 6)
            .anchor(\.leadingAnchor, referentTo: self, equal: \.leadingAnchor, constant: 6)
            .anchor(\.trailingAnchor, referentTo: self, equal: \.trailingAnchor, constant: 6)
            .anchor(\.bottomAnchor, referentTo: self, equal: \.bottomAnchor)

    }
}
