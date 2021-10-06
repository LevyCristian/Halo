//
//  ShowViewModelDataSource.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import Foundation

protocol ShowViewModelDataSource {
    typealias Seasons = [Int: [EpisodeViewModelDataSource]]

    var service: ShowsUseCaseProtocol { get set }

    var show: Show { get set }

    var episodesModelDataSource: Seasons { get }

    var delegate: ShowViewModelDelegate? { get set }

    func getShowEpisodes(with id: Int)
    func downloadImage(from url: String)
}
