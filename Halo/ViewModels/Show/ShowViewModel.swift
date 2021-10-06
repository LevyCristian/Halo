//
//  ShowViewModel.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import Foundation

class ShowViewModel: ShowViewModelDataSource {
    private let service: ShowsUseCaseProtocol

    var show: Show
    var discoveryCellViewModels: [DiscoveryCellViewModelDataSource] = []
    weak var delegate: ShowViewModelDelegate?

    init(_ show: Show, service: ShowsUseCaseProtocol) {
        self.show = show
        self.service = service

        self.getShowEpisodes(for: show.id)

        if let imageData = self.show.downloadedImageData {
            self.delegate?.didFinishedDownloadingImage(data: imageData)
        }
        if let imageURL = show.image?.original {
            self.downloadImage(from: imageURL)
        }
    }

    func getShowEpisodes(for id: Int) {

    }

    func downloadImage(from url: String) {
        self.service.downloadImage(from: url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.show.downloadedImageData = imageData
                self?.delegate?.didFinishedDownloadingImage(data: imageData)
            case .failure(let error):
                self?.delegate?.apiDidReturnAnError(error: error)
            }
        }
    }
}
