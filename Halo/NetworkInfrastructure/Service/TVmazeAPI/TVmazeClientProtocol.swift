//
//  TVmazeClientProtocol.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

protocol TVmazeClientProtocol {

    func getshows(at page: Int, completion: @escaping ((Result<[Show], APIError>) -> Void))
    func downloadImage(from url: String, completion: @escaping ((Result<Data, APIError>) -> Void))
    func searchShows(with query: String, completion: @escaping ((Result<[Show], APIError>) -> Void))

}
