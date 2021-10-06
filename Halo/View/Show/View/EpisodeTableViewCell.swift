//
//  EpisodeTableViewCell.swift
//  Halo
//
//  Created by Levy Cristian on 06/10/21.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    lazy var episodeImageView: UIImageView = {
        let view = UIImageView()
            .set(\.contentMode, to: .scaleAspectFill)
            .set(\.clipsToBounds, to: true)
            .set(\.layer.cornerRadius, to: 8)
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.contentMode = .scaleAspectFit
        stack.spacing = 4
        stack.isUserInteractionEnabled = false
        return stack
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
            .set(\.numberOfLines, to: 2)
            .set(\.textColor, to: .white)
        return label
    }()

    lazy var minutesLabel: UILabel = {
        let label = UILabel()
            .set(\.numberOfLines, to: 1)
            .set(\.font, to: .systemFont(ofSize: 15, weight: .regular))
            .set(\.textColor, to: .lightGray)
        return label
    }()

    lazy var sumaryLabel: UILabel = {
        let label = UILabel()
            .set(\.numberOfLines, to: 3)
            .set(\.textColor, to: .lightGray)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }

    func configure(title: String, minutes: Int?, sumary: String?) {
        titleLabel
            .set(\.text, to: title)
        contentStackView.addArrangedSubview(titleLabel)
        if let minutes = minutes {
            minutesLabel
                .set(\.text, to: "\(minutes) min")
            contentStackView.addArrangedSubview(minutesLabel)
        }
        sumaryLabel
            .set(\.text, to: sumary)
    }
}

extension EpisodeTableViewCell: ViewCode {
    func buildViewHierarchy() {
        addSubview(episodeImageView)
        addSubview(contentStackView)
        addSubview(sumaryLabel)
    }

    func setupConstraints() {
        episodeImageView
            .anchor(\.topAnchor,
                     referentTo: self,
                     equal: \.topAnchor, constant: 24)
            .anchor(\.leadingAnchor,
                     referentTo: self,
                     equal: \.leadingAnchor, constant: 8)
            .anchor(\.widthAnchor, equalToConstant: 120)
            .anchor(\.heightAnchor, equalToConstant: 80)

        contentStackView
            .anchor(\.leadingAnchor,
                     referentTo: episodeImageView,
                     equal: \.trailingAnchor,
                     constant: 8)
            .anchor(\.trailingAnchor,
                     referentTo: self,
                     equal: \.trailingAnchor,
                     constant: -8)
            .anchor(\.centerYAnchor,
                     referentTo: episodeImageView,
                     equal: \.centerYAnchor)

        sumaryLabel
            .anchor(\.topAnchor,
                     referentTo: episodeImageView,
                     equal: \.bottomAnchor,
                     constant: 8)
            .anchor(\.leadingAnchor,
                     referentTo: self,
                     equal: \.leadingAnchor,
                     constant: 8)
            .anchor(\.trailingAnchor,
                     referentTo: self,
                     equal: \.trailingAnchor,
                     constant: -8)
            .anchor(\.bottomAnchor,
                     referentTo: self,
                     equal: \.bottomAnchor,
                     constant: -24)

    }

    func setupAdditionalConfigurantion() {
        self
            .set(\.backgroundColor, to: .black)
            .set(\.selectionStyle, to: .none)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.episodeImageView.image = nil
    }
}
