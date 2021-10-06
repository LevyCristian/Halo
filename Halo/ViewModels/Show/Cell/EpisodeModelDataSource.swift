//
//  EpisodeModelDataSource.swift
//  Halo
//
//  Created by Levy Cristian on 06/10/21.
//

import Foundation

protocol EpisodeModelDataSource {
    var service: ShowsUseCaseProtocol { get set }

    var season: Int { get set }
    var episode: Episode { get set}

    var delegate: EpisodeViewModelDelegate? { get set }

    var indexPath: IndexPath? { get set }

    func downloadImage(from url: String)
}
