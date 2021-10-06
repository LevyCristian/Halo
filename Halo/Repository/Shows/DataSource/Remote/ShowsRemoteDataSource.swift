//
//  ShowsRemoteDataSource.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation

class ShowsRemoteDataSource: ShowsRemoteDataSourceProtocol {

    private let client: TVmazeClientProtocol

    init(client: TVmazeClientProtocol) {
        self.client = client
    }

    func getshows(at page: Int, completion: @escaping ((Result<[Show], APIError>) -> Void)) {
        self.client.getshows(at: page) { result in
            completion(result)
        }
    }

    func downloadImage(from url: String, completion: @escaping ((Result<Data, APIError>) -> Void)) {
        self.client.downloadImage(from: url) { result in
            completion(result)
        }
    }

    func searchShows(with query: String, completion: @escaping ((Result<[SearchElement], APIError>) -> Void)) {
        self.client.searchShows(with: query) { result in
            completion(result)
        }
    }

    func getEpisodes(with id: Int, completion: @escaping ((Result<[Episode], APIError>) -> Void)) {
        self.client.getEpisodes(with: id) { result in
            completion(result)
        }
    }
}
