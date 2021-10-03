//
//  Descriptable.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

protocol Descriptable {
    /// A literal description of a object stance
    var description: String { get }
}

protocol ErrorDescriptable: Descriptable {}
