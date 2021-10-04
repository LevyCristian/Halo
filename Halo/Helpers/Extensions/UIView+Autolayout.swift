//
//  UIView+Autolayout.swift
//  Halo
//
//  Created by Levy Cristian on 03/10/21.
//

import UIKit

protocol With {}

extension With where Self: AnyObject {
    @discardableResult
    func set<T>(_ property: ReferenceWritableKeyPath<Self, T>, to value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
}

protocol Anchor: UIView {}

extension Anchor {
    @discardableResult
    func anchor<T, U>(_ from: KeyPath<UIView, T>,
                      referentTo referent: U,
                      equal to: KeyPath<U, T>,
                      constant: CGFloat = 0,
                      multipler: CGFloat = 0) -> Self where T: NSLayoutDimension {
        self.translatesAutoresizingMaskIntoConstraints = false
        self[keyPath: from].constraint(
            greaterThanOrEqualTo: referent[keyPath: to],
            multiplier: multipler, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func anchor<T>(_ from: KeyPath<UIView, T>,
                   equalToConstant constant: CGFloat) -> Self where T: NSLayoutDimension {
        self.translatesAutoresizingMaskIntoConstraints = false
        self[keyPath: from].constraint(equalToConstant: constant).isActive = true
        return self
    }

    @discardableResult
    func anchor<T, Axis, U>(_ from: KeyPath<UIView, T>,
                            referentTo referent: U,
                            equal to: KeyPath<U, T>,
                            constant: CGFloat = 0) -> Self where T: NSLayoutAnchor<Axis> {
        self.translatesAutoresizingMaskIntoConstraints = false
        self[keyPath: from].constraint(equalTo: referent[keyPath: to], constant: constant).isActive = true
        return self
    }
}

extension UIView: With, Anchor {}
