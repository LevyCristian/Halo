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
}
