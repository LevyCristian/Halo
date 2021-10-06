//
//  DiscoveryCellViewModel.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import UIKit

class DiscoveryCellViewModel: DiscoveryCellViewModelDataSource {

    private let service: ShowsUseCaseProtocol

    var show: Show

    var indexPath: IndexPath?

    weak var delegate: DiscoveryCellViewModelDelegate?

    init(show: Show, service: ShowsUseCaseProtocol) {
        self.show = show
        self.service = service
    }

    func downloadImage(from url: String) {
        self.service.downloadImage(from: url) { [weak self] result in
            guard let indexpath = self?.indexPath else {
                return
            }
            switch result {
            case .success(let data):
                self?.show.downloadedImageData = data
                self?.delegate?.didFinishedDownloadingImage(data: data, forRowAt: indexpath)
            case .failure(let error):
                self?.delegate?.apiDidReturnAnError(error: error)
            }
        }
    }
}
