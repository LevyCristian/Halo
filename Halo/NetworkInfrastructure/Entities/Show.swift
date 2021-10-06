//
//  Show.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

// MARK: - ShowElement
struct Show: Codable {
    let id: Int
    let url: String
    let name: String
    let type: String
    let language: String
    let genres: [String]
    let status: String
    let runtime: Int?
    let averageRuntime: Int?
    let premiered: String?
    let ended: String?
    let officialSite: String?
    let schedule: Schedule?
    let rating: Rating?
    let weight: Int
    let externals: Externals?
    let image: Image?
    let summary: String?
    let updated: Int

    var downloadedImageData: Data?
}

// MARK: - Externals
struct Externals: Codable {
    let tvrage: Int?
    let thetvdb: Int?
    let imdb: String?
}

// MARK: - Image
struct Image: Codable {
    let medium, original: String
}

// MARK: - Rating
struct Rating: Codable {
    let average: Double?
}

// MARK: - Schedule
struct Schedule: Codable {
    let time: String
    let days: [String]
}
