//
//  SearchViewModelDataSource.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import Foundation

protocol SearchViewModelDataSource {
    var service: ShowsUseCaseProtocol { get set }

    var shows: [Show] { get set }
    var discoveryCellViewModels: [DiscoveryCellViewModelDataSource] { get }

    var delegate: DiscoveryViewModelDelegate? { get set }

    func searchShows(with query: String)
}
