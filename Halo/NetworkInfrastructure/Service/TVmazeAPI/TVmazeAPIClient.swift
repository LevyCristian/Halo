//
//  TVmazeAPIClient.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

class TVmazeAPIClient: APIClient, TVmazeClientProtocol {

    var session: URLSession

    init(configuration: URLSessionConfiguration =  URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }

    func getshows(at page: Int, completion: @escaping ((Result<[Show], APIError>) -> Void)) {
        guard let request = TVmazeAPIProvider.shows(page).request else {
            completion(.failure(.badRequest))
            return
        }
        self.handlePerformData(request: request, completion: completion)
    }

    func downloadImage(from url: String, completion: @escaping ((Result<Data, APIError>) -> Void)) {
        guard let url = URL(string: url) else {
            completion(.failure(.badRequest))
            return
        }
        let request = URLRequest(url: url)
        self.handlePerformData(request: request, completion: completion)
    }

    func searchShows(with query: String, completion: @escaping ((Result<[SearchElement], APIError>) -> Void)) {
        guard let request = TVmazeAPIProvider.search(query).request else {
            completion(.failure(.badRequest))
            return
        }
        self.handlePerformData(request: request, completion: completion)
    }
    
    func getEpisodes(with id: Int, completion: @escaping ((Result<[Episode], APIError>) -> Void)) {
        guard let request = TVmazeAPIProvider.episodes(id).request else {
            completion(.failure(.badRequest))
            return
        }
        self.handlePerformData(request: request, completion: completion)
    }
    
    private func handlePerformData<T: Decodable>(request: URLRequest,
                                   completion: @escaping ((Result<T, APIError>) -> Void)) {
        perform(with: request, decode: { json -> T? in
            guard let object = json as? T else {
                return nil
            }
            return object
        }, completion: completion)
    }
}
