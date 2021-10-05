//
//  DiscoveryScrollDelegate.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation

protocol DiscoveryScrollDelegate: AnyObject {
    func scrollViewDidScroll(_ direction: Direction)
}

enum Direction {
    case up
    case down
}
