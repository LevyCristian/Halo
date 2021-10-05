//
//  DiscoveryViewModel.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation

class DiscoveryViewModel: DiscoveryViewModelDataSource {

    private let service: ShowsUseCaseProtocol

    var shows: [Show] = []
    var discoveryCellViewModels: [DiscoveryCellViewModelDataSource] = []
    var currentPage: Int = 0

    weak var delegate: DiscoveryViewModelDelegate?

    init(service: ShowsUseCaseProtocol) {
        self.service = service
        loadShows(at: currentPage)
    }

    func loadShows(at page: Int,
                   completion: ((Result<Bool, APIError>) -> Void)? = nil) {
        self.service.getshows(at: page) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let responseShows):
                self.shows.append(contentsOf: responseShows)
                self.discoveryCellViewModels = self.shows.map({
                    DiscoveryCellViewModel(show: $0,
                                           service: self.service)
                })
                self.delegate?.didCompleLoadingShows(models: self.discoveryCellViewModels)
                completion?(.success(true))
            case .failure(let error):
                self.delegate?.apiDidReturnAnError(error: error)
                completion?(.failure(error))
            }
        }
    }
}
