//
//  EpisodeViewModel.swift
//  Halo
//
//  Created by Levy Cristian on 06/10/21.
//

import Foundation

class EpisodeViewModel: EpisodeViewModelDataSource {

    var service: ShowsUseCaseProtocol

    var season: Int = 0
    var episode: Episode

    var indexPath: IndexPath?

    weak var delegate: EpisodeViewModelDelegate?

    init(episode: Episode, service: ShowsUseCaseProtocol) {
        self.episode = episode
        self.season = episode.season
        self.service = service
    }

    func downloadImage(from url: String) {
        self.service.downloadImage(from: url) { [weak self] result in
            guard let indexpath = self?.indexPath else {
                return
            }
            switch result {
            case .success(let data):
                self?.delegate?.didFinishedDownloadingImage(data: data, forRowAt: indexpath)
            case .failure(let error):
                self?.delegate?.apiDidReturnAnError(error: error)
            }
        }
    }
}
