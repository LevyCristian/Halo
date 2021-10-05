//
//  RootTabBarController.swift
//  Halo
//
//  Created by Levy Cristian on 03/10/21.
//

import UIKit

class RootTabBarController: FloatyTabBarController {

    private let client = TVmazeAPIClient()

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
        viewControllers = [
            factorController(type: .discovery, at: 0),
            factorController(type: .search, at: 1)
        ]
    }

    private func factorController(type: Controllers, at index: Int) -> UINavigationController {

        var navigation: UINavigationController
        let item = UITabBarItem()
        item.tag = index

        switch type {
        case .discovery:
            let remoteRepository =  ShowsRemoteDataSource(client: client)
            let repository = ShowsRepository(remoteDataSource: remoteRepository)
            let viewModel = DiscoveryViewModel(service: repository)

            let controller = DiscoveryViewController(viewModel: viewModel)
            controller.scrollDelegate = self
            controller.title = type.rawValue
            navigation = UINavigationController(rootViewController: controller)
            navigation.navigationBar.prefersLargeTitles = true
            item.image = UIImage(systemName: "play.rectangle.fill")

        case .search:
            let controller = SearchViewController()
            controller.title = type.rawValue
            navigation = UINavigationController(rootViewController: controller)
            navigation.navigationBar.prefersLargeTitles = true
            item.image = UIImage(systemName: "magnifyingglass")
        }

        configureNavApparence(nav: navigation)
        navigation.tabBarItem = item
        return navigation
    }

    private enum Controllers: String {
        case discovery = "Discovery"
        case search = "Search"
    }

    private func configureNavApparence(nav: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        let appearanceLager = UINavigationBarAppearance()

        appearance.configureWithTransparentBackground()
        appearanceLager.configureWithTransparentBackground()

        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearanceLager.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearanceLager.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        let blurEffect = UIBlurEffect(style: .dark)
        appearance.backgroundEffect = blurEffect

        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearanceLager
        if #available(iOS 15.0, *) {
            nav.navigationBar.compactScrollEdgeAppearance = appearance
        }

    }
}

extension RootTabBarController: DiscoveryScrollDelegate {
    func scrollViewDidScroll(_ direction: Direction) {
        switch direction {
        case .up:
            self.setTabBarHidden(false, animated: true)
        case .down:
            self.setTabBarHidden(true, animated: true)
        }
    }
}
