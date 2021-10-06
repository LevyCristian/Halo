//
//  FloatyTabBarController.swift
//  Halo
//
//  Created by Levy Cristian on 03/10/21.
//

import UIKit

class FloatyTabBarController: UITabBarController {

    var tabBarHeight: CGFloat {
        customTabBar.preferredTabBarHeight
    }

    lazy var customTabBar: BaseCardTabBar = makeTabBar()
    lazy var anotherSmallView = UIView()

    fileprivate var anotherSmallViewBottomConstraint: NSLayoutConstraint?
    fileprivate var tabBarHeightConstraint: NSLayoutConstraint?

    lazy var bottomPadding: CGFloat = {
        let window = UIApplication.shared.windows.first
        return (window?.safeAreaInsets.bottom ?? 0)
    }()

    override var selectedIndex: Int {
        didSet {
            customTabBar.select(at: selectedIndex, animated: false, notifyDelegate: false)
        }
    }

    override var selectedViewController: UIViewController? {
        didSet {
            customTabBar.select(at: selectedIndex, animated: false, notifyDelegate: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.isHidden = true

        setupTabBar()
        updateTabBarHeightIfNeeded()
        setupBlur()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        customTabBar.set(items: tabBar.items ?? [])
        customTabBar.select(at: selectedIndex, animated: false, notifyDelegate: true)
    }

    fileprivate func setupTabBar() {
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)

        customTabBar.delegate = self
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customTabBar)

        anotherSmallView.backgroundColor = customTabBar.preferredBottomBackground
        anotherSmallView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(anotherSmallView)

        anotherSmallView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        anotherSmallView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        anotherSmallView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        customTabBar.bottomAnchor.constraint(equalTo: anotherSmallView.topAnchor).isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        self.view.bringSubviewToFront(customTabBar)
        self.view.bringSubviewToFront(anotherSmallView)
    }

    fileprivate func updateTabBarHeightIfNeeded() {
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight - bottomPadding, right: 0)

        tabBarHeightConstraint = customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight)
        tabBarHeightConstraint?.isActive = true

        anotherSmallViewBottomConstraint = anotherSmallView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: tabBarHeight)

        anotherSmallViewBottomConstraint?.priority = .defaultHigh
        anotherSmallViewBottomConstraint?.isActive = true
    }

    func setTabBarHidden(_ isHidden: Bool, animated: Bool) {
        let block = { [weak self] in
            guard let self = self else {
                return
            }
            self.customTabBar.alpha = isHidden ? 0 : 1
            self.additionalSafeAreaInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: isHidden ? 0 : self.tabBarHeight - self.bottomPadding,
                right: 0
            )
        }

        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: block, completion: nil)
        } else {
            block()
        }
    }

    func makeTabBar() -> BaseCardTabBar {
        FloatyTabBar()
    }

    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = .flexibleWidth
        customTabBar.containerView.insertSubview(blurView, at: 0)
    }
}

extension FloatyTabBarController: CardTabBarDelegate {
    func cardTabBar(_ sender: BaseCardTabBar, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }

    func didUpdateHeight() {
        self.updateTabBarHeightIfNeeded()
    }
}
