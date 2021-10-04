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
    var currentPage: Int = 0

    weak var delegate: ShowsViewModelDelegate?

    init(service: ShowsUseCaseProtocol) {
        self.service = service
    }

    func loadShows(at page: Int) {
        self.service.getshows(at: page) { [weak self] result in
            switch result {
            case .success(let shows):
                self?.shows.append(contentsOf: shows)
                self?.currentPage = page
                self?.delegate?.didCompleLoadingShows(models: shows)
            case .failure(let error):
                self?.delegate?.apiDidReturnAnError(error: error)
            }
        }
    }
}
