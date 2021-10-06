//
//  ShowViewModelDataSource.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import Foundation

protocol ShowViewModelDataSource {
    var show: Show { get set }

    var discoveryCellViewModels: [DiscoveryCellViewModelDataSource] { get }

    var delegate: ShowViewModelDelegate? { get set }

    func getShowEpisodes(for id: Int)
    func downloadImage(from url: String)
}
