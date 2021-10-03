//
//  Show.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

// MARK: - Show
struct Show: Codable {
    let id: Int
    let url: String
    let name, type, language: String
    let genres: [String]
    let status: String
    let runtime, averageRuntime: Int
    let premiered, ended: String
    let officialSite: String
    let schedule: Schedule
    let rating: Rating
    let weight: Int
    let externals: Externals
    let image: Image
    let summary: String
    let updated: Int
    let links: ShowLinks
    let embedded: Embedded

    enum CodingKeys: String, CodingKey {
        case id, url, name, type, language, genres, status, runtime, averageRuntime
        case premiered, ended, officialSite, schedule, rating, weight, externals, image, summary, updated
        case links = "_links"
        case embedded = "_embedded"
    }
}

// MARK: - Embedded
struct Embedded: Codable {
    let cast: [Cast]
}

// MARK: - Cast
struct Cast: Codable {
    let person: Person
    let character: Character
}

// MARK: - Character
struct Character: Codable {
    let id: Int
    let name: String
}

// MARK: - Image
struct Image: Codable {
    let medium, original: String
}

// MARK: - Previousepisode
struct Previousepisode: Codable {
    let href: String
}

// MARK: - Person
struct Person: Codable {
    let id: Int
    let name: String
    let image: Image
}

// MARK: - Externals
struct Externals: Codable {
    let tvrage, thetvdb: Int
    let imdb: String
}

// MARK: - ShowLinks
struct ShowLinks: Codable {
    let link, previousepisode: Previousepisode

    enum CodingKeys: String, CodingKey {
        case link = "self"
        case previousepisode
    }
}

// MARK: - Rating
struct Rating: Codable {
    let average: Double
}

// MARK: - Schedule
struct Schedule: Codable {
    let time: String
    let days: [String]
}
