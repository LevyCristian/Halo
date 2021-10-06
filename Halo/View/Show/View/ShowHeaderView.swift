//
//  ShowHeaderView.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import UIKit

class ShowHeaderView: UIView {

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
            .set(\.axis, to: .vertical)
            .set(\.contentMode, to: .scaleAspectFit)
        stack.spacing = 8
        return stack
    }()

    lazy var posterImageView: UIImageView = {
        let view = UIImageView()
            .set(\.contentMode, to: .scaleAspectFill)
            .set(\.clipsToBounds, to: true)
            .set(\.backgroundColor, to: .gray)
        return view
    }()

    private lazy var informationStack: UIStackView = {
        let stack = UIStackView()
            .set(\.axis, to: .vertical)
            .set(\.contentMode, to: .scaleAspectFit)
            .set(\.layoutMargins, to: UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12))
            .set(\.isLayoutMarginsRelativeArrangement, to: true)
        stack.spacing = 12
        return stack
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
            .set(\.textColor, to: .white)
            .set(\.textAlignment, to: .center)
            .set(\.numberOfLines, to: 2)
            .set(\.font, to: UIFont.systemFont(ofSize: 24, weight: .semibold))
        return label
    }()

    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
            .set(\.textAlignment, to: .center)
            .set(\.numberOfLines, to: 2)
            .set(\.textColor, to: .lightGray)
            .set(\.font, to: UIFont.systemFont(ofSize: 18, weight: .regular))
        return label
    }()

    lazy var scheduleStackView: UIStackView = {
        let stackView = UIStackView()
            .set(\.contentMode, to: .scaleAspectFit)
            .set(\.axis, to: .horizontal)
        return stackView
    }()

    lazy var sumary: UILabel = {
        let label = UILabel()
            .set(\.textColor, to: .lightGray)
            .set(\.font, to: UIFont.systemFont(ofSize: 18, weight: .regular))
            .set(\.textAlignment, to: .center)
            .set(\.numberOfLines, to: 0)
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

extension ShowHeaderView: ViewCode {

    func buildViewHierarchy() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(posterImageView)
        contentStackView.addArrangedSubview(informationStack)
        informationStack.addArrangedSubview(titleLabel)
        informationStack.addArrangedSubview(subTitleLabel)
        informationStack.addArrangedSubview(scheduleStackView)
        informationStack.addArrangedSubview(sumary)
    }

    func setupConstraints() {
        let photoHeight = UIScreen.main.bounds.height * 0.6
        contentStackView
            .anchor(\.topAnchor,
                     referentTo: self,
                     equal: \.topAnchor)
            .anchor(\.leadingAnchor,
                     referentTo: self,
                     equal: \.leadingAnchor)
            .anchor(\.trailingAnchor,
                     referentTo: self,
                     equal: \.trailingAnchor)
            .anchor(\.bottomAnchor,
                     referentTo: self,
                     equal: \.bottomAnchor)

        posterImageView
            .anchor(\.heightAnchor,
                     equalToConstant: photoHeight)
    }

    func setupAdditionalConfigurantion() {
        addgradient()
        self.set(\.backgroundColor, to: .black)

    }

    private func addgradient() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        let size = CGSize(width: UIScreen.main.bounds.width,
                          height: UIScreen.main.bounds.height * 0.6)
        gradientLayer.frame.size = size
        gradientLayer.colors = [UIColor.black.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.black.cgColor]
        posterImageView.layer.addSublayer(gradientLayer)
    }
}
