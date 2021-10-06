//
//  Episode.swift
//  Halo
//
//  Created by Levy Cristian on 06/10/21.
//

import Foundation

// MARK: - EpisodeElement
struct Episode: Codable {
    let id: Int
    let url: String
    let name: String
    let season, number: Int
    let type: String
    let airdate: String
    let airtime: String
    let airstamp: String?
    let runtime: Int?
    let image: Image?
    let summary: String?

    var downloadedImageData: Data?
}
