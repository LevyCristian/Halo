//
//  Identifiable.swift
//  Halo
//
//  Created by Levy Cristian on 03/10/21.
//

import UIKit

public protocol Identifiable {
    static var reuseIdentifier: String { get }
}

extension Identifiable {
    public static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: Identifiable {}
