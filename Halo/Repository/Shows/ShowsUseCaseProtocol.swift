//
//  ShowsUseCaseProtocol.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation

protocol ShowsUseCaseProtocol {
    func getshows(at page: Int, completion: @escaping ((Result<[Show], APIError>) -> Void))
}
