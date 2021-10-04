//
//  RootTabBarController.swift
//  Halo
//
//  Created by Levy Cristian on 03/10/21.
//

import UIKit

class RootTabBarController: FloatyTabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        configureControllers()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureControllers()
    }

    override func makeTabBar() -> BaseCardTabBar {
        return FloatyTabBar()
    }

    private func configureControllers() {
        viewControllers = [factorController(type: .discovery, at: 0)]
    }

    private func factorController(type: Controllers, at index: Int) -> UINavigationController {
        var navigation: UINavigationController
        var controller: UIViewController

        controller = DiscoveryViewController()
        controller.title = type.rawValue
        navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.prefersLargeTitles = true

        let item = UITabBarItem()
        item.tag = index
        item.image = UIImage(systemName: "play.rectangle.fill")

        navigation.tabBarItem = item

        return navigation
    }

    private enum Controllers: String {
        case discovery = "Discovery"
    }
}
