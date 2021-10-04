//
//  FloatyTabBar.swift
//  Halo
//
//  Created by Levy Cristian on 03/10/21.
//

import UIKit

class FloatyTabBar: BaseCardTabBar {

    override var preferredTabBarHeight: CGFloat {
        75
    }

    override var preferredBottomBackground: UIColor {
        .clear
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
            .set(\.axis, to: .horizontal)
            .set(\.distribution, to: .fillEqually)
            .set(\.alignment, to: .center)
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    deinit {
        stackView.arrangedSubviews.forEach {
            if let button = $0 as? UIControl {
                button.removeTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            }
        }
    }

    func updateStyle() {
        containerView
            .set(\.layer.shadowColor, to: UIColor.black.cgColor)
            .set(\.layer.shadowOffset, to: CGSize(width: 3, height: 3))
            .set(\.layer.shadowRadius, to: 6)
            .set(\.layer.shadowOpacity, to: 0.15)
            .set(\.clipsToBounds, to: true)
    }

    override func set(items: [UITabBarItem]) {
        for button in (stackView.arrangedSubviews.compactMap { $0 as? PTBarButton }) {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
            button.removeTarget(self, action: nil, for: .touchUpInside)
        }

        for item in items {
            if let image = item.image {
                addButton(with: image)
            } else {
                addButton(with: UIImage())
            }
        }
        layoutIfNeeded()
    }

    override func select(at index: Int, animated: Bool, notifyDelegate: Bool) {
        for (bIndex, button) in buttons().enumerated() {
            button.selectedColor = .systemBlue
            button.isSelected = bIndex == index
        }

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }

        if notifyDelegate {
            self.delegate?.cardTabBar(self, didSelectItemAt: index)
        }
    }

    private func addButton(with image: UIImage) {
        let button = PTBarButton(image: image)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.selectedColor = .black

        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        self.stackView.addArrangedSubview(button)
    }

    private func buttons() -> [PTBarButton] {
        return stackView.arrangedSubviews.compactMap { $0 as? PTBarButton }
    }

    @objc func buttonTapped(sender: PTBarButton) {
        if let index = stackView.arrangedSubviews.firstIndex(of: sender) {
            select(at: index, animated: true, notifyDelegate: true)
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = touches.first?.location(in: self) else {
            super.touchesEnded(touches, with: event)
            return
        }

        let buttons = self.stackView.arrangedSubviews.compactMap { $0 as? PTBarButton }.filter { !$0.isHidden }
        let distances = buttons.map { $0.center.distance(to: position) }

        let buttonsDistances = zip(buttons, distances)

        if let closestButton = buttonsDistances.min(by: { $0.1 < $1.1 }) {
            buttonTapped(sender: closestButton.0)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = containerView.bounds.height / 2
    }
}

extension FloatyTabBar {

    public class PTBarButton: UIButton {

        var selectedColor: UIColor = .black {
            didSet {
                reloadApperance()
            }
        }

        var unselectedColor: UIColor = .lightGray {
            didSet {
                reloadApperance()
            }
        }

        init(forItem item: UITabBarItem) {
            super.init(frame: .zero)
            setImage(item.image, for: .normal)
        }

        init(image: UIImage) {
            super.init(frame: .zero)
            setImage(image, for: .normal)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override public var isSelected: Bool {
            didSet {
                reloadApperance()
            }
        }

        func reloadApperance() {
            self.tintColor = isSelected ? selectedColor : unselectedColor
        }
    }

}

extension FloatyTabBar: ViewCode {
    func buildViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(stackView)
    }

    func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        containerView
            .anchor(\.topAnchor,
                     referentTo: self,
                     equal: \.topAnchor)
            .anchor(\.leadingAnchor,
                     referentTo: self,
                     equal: \.leadingAnchor,
                     constant: 20)
            .anchor(\.trailingAnchor,
                     referentTo: self,
                     equal: \.trailingAnchor,
                     constant: -20)
            .anchor(\.bottomAnchor,
                     referentTo: self,
                     equal: \.bottomAnchor,
                     constant: -15)

        stackView
            .anchor(\.topAnchor,
                     referentTo: self,
                     equal: \.topAnchor)
            .anchor(\.leadingAnchor,
                     referentTo: containerView,
                     equal: \.leadingAnchor,
                     constant: 20)
            .anchor(\.trailingAnchor,
                     referentTo: containerView,
                     equal: \.trailingAnchor,
                     constant: -20)
            .anchor(\.centerXAnchor,
                     referentTo: containerView,
                     equal: \.centerXAnchor)
            .anchor(\.centerYAnchor,
                     referentTo: containerView,
                     equal: \.centerYAnchor)
    }

    func setupAdditionalConfigurantion() {
        updateStyle()
    }
}
