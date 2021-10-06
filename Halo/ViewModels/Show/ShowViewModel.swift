//
//  ShowViewModel.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import Foundation

class ShowViewModel: ShowViewModelDataSource {

    var service: ShowsUseCaseProtocol

    var show: Show
    var episodesModelDataSource: Seasons = [:]
    weak var delegate: ShowViewModelDelegate?

    init(_ show: Show, service: ShowsUseCaseProtocol) {
        self.show = show
        self.service = service

        self.getShowEpisodes(with: show.id)

        if let imageData = self.show.downloadedImageData {
            self.delegate?.didFinishedDownloadingImage(data: imageData)
        }
        if let imageURL = show.image?.original {
            self.downloadImage(from: imageURL)
        }
    }

    func getShowEpisodes(with id: Int) {
        self.service.getEpisodes(with: id) { [weak self] result in
            guard let self = self else {
                 return
            }
            switch result {
            case .success(let episodes):
                self.show.episodes = episodes
                self.episodesModelDataSource = self.prepareSeasons(episode: episodes)
                self.delegate?.didCompleLoadingEpisodes(models: self.episodesModelDataSource)
            case .failure(let error):
                self.delegate?.apiDidReturnAnError(error: error)
            }
        }
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

    func prepareSeasons(episode: [Episode]) -> Seasons {
        var seasons: Seasons = [:]
        episode.forEach { [weak self] in
            guard let self = self else {
                return
            }
            if seasons[$0.season] != nil {
                seasons[$0.season]?.append(EpisodeViewModel(episode: $0, service: self.service))
            } else {
                seasons[$0.season] = [EpisodeViewModel(episode: $0, service: self.service)]
            }

        }
        return seasons
    }
}
