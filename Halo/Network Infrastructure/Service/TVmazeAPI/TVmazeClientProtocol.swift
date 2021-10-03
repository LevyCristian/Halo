//
//  TVmazeClientProtocol.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

protocol TVmazeClientProtocol {

    func getshows(at page: Int, completion: @escaping ((Result<[Show], APIError>) -> Void))

}
