//
//  DiscoveryViewModel.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation

class DiscoveryViewModel: PostsViewModelDataSource {

    private let service: ShowsUseCaseProtocol

    var shows: [Show] = []
    var discoveryCellViewModels: [DiscoveryCellViewModelDataSource] = []
    var currentPage: Int = 0

    weak var delegate: ShowsViewModelDelegate?

    init(service: ShowsUseCaseProtocol) {
        self.service = service
        self.loadShows(at: currentPage)
    }

    func loadShows(at page: Int) {
        self.service.getshows(at: page) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let shows):
                self.shows.append(contentsOf: shows)
                self.currentPage = page
                self.discoveryCellViewModels = shows.map({
                    DiscoveryCellViewModel(show: $0,
                                           service: self.service)
                })
                self.delegate?.didCompleLoadingShows(models: self.discoveryCellViewModels)
            case .failure(let error):
                self.delegate?.apiDidReturnAnError(error: error)
            }
        }
    }
}
