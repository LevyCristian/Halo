//
//  BaseCardTabBar.swift
//  Halo
//
//  Created by Levy Cristian on 03/10/21.
//

import UIKit

protocol CardTabBarDelegate: AnyObject {
    func cardTabBar(_ sender: BaseCardTabBar, didSelectItemAt index: Int)

    func didUpdateHeight()
}

class BaseCardTabBar: UIView {

    var preferredTabBarHeight: CGFloat {
        70
    }

    lazy var containerView: UIView = UIView()

    var preferredBottomBackground: UIColor {
        .clear
    }

    weak var delegate: CardTabBarDelegate?

    func select(at index: Int, animated: Bool, notifyDelegate: Bool) {

    }

    func set(items: [UITabBarItem]) {

    }
}
