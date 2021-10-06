//
//  ShowsRepository.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation

class ShowsRepository: ShowsUseCaseProtocol {

    private var remoteDataSource: ShowsRemoteDataSourceProtocol

    init(remoteDataSource: ShowsRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getshows(at page: Int, completion: @escaping ((Result<[Show], APIError>) -> Void)) {
        self.remoteDataSource.getshows(at: page) { result in
            completion(result)
        }
    }

    func downloadImage(from url: String, completion: @escaping ((Result<Data, APIError>) -> Void)) {
        self.remoteDataSource.downloadImage(from: url) { result in
            completion(result)
        }
    }

    func searchShows(with query: String, completion: @escaping ((Result<[SearchElement], APIError>) -> Void)) {
        self.remoteDataSource.searchShows(with: query) { result in
            completion(result)
        }
    }

    func getEpisodes(with id: Int, completion: @escaping ((Result<[Episode], APIError>) -> Void)) {
        self.remoteDataSource.getEpisodes(with: id) { result in
            completion(result)
        }
    }
}
