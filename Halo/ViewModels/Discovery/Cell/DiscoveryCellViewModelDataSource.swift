//
//  DiscoveryCellViewModelDataSource.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation
import UIKit

protocol DiscoveryCellViewModelDataSource {

    var show: Show { get set }
    var indexPath: IndexPath? { get set }

    var delegate: DiscoveryCellViewModelDelegate? { get set }

    func downloadImage(from url: String)
}
