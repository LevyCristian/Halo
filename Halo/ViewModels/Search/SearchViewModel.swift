//
//  SearchViewModel.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import Foundation

class SearchViewModel: SearchViewModelDataSource {

    private let service: ShowsUseCaseProtocol

    var shows: [Show] = []
    var discoveryCellViewModels: [DiscoveryCellViewModelDataSource] = []

    weak var delegate: DiscoveryViewModelDelegate?

    init(service: ShowsUseCaseProtocol) {
        self.service = service
    }

    func searchShows(with query: String) {
        self.service.searchShows(with: query) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let searchElements):
                self.shows  = searchElements.compactMap({ $0.show })
                self.discoveryCellViewModels = self.shows.map({
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
