//
//  DiscoveryModelDataSource.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation

protocol DiscoveryViewModelDataSource {
    var shows: [Show] { get set }
    var currentPage: Int { get set }

    var discoveryCellViewModels: [DiscoveryCellViewModelDataSource] { get }

    var delegate: DiscoveryViewModelDelegate? { get set }

    func loadShows(at page: Int, completion: ((Result<Bool, APIError>) -> Void)?)
}
