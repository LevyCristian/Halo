//
//  TVmazeAPIClient.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

class TVmazeAPIClient: APIClient, TVmazeClientProtocol {

    var session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
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
}
