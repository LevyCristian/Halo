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
        perform(with: request, decode: { json -> [Show]? in
            guard let user = json as? [Show] else {
                return nil
            }
            return user
        }, completion: completion)
    }

    func downloadImage(from url: String, completion: @escaping ((Result<Data, APIError>) -> Void)) {
        guard let url = URL(string: url) else {
            completion(.failure(.badRequest))
            return
        }
        let request = URLRequest(url: url)
        perform(with: request, decode: { json -> Data? in
            guard let image = json as? Data else {
                return nil
            }
            return image
        }, completion: completion)
    }

    func searchShows(with query: String, completion: @escaping ((Result<[SearchElement], APIError>) -> Void)) {
        guard let request = TVmazeAPIProvider.search(query).request else {
            completion(.failure(.badRequest))
            return
        }
        perform(with: request, decode: { json -> [SearchElement]? in
            guard let user = json as? [SearchElement] else {
                return nil
            }
            return user
        }, completion: completion)
    }
}
