//
//  APIError.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

enum APIError: Error, ErrorDescriptable {

    case notFound
    case networkProblem
    case badRequest
    case requestFailed
    case invalidData
    case unknown(HTTPURLResponse?)

    init(response: URLResponse?) {
        guard let response = response as? HTTPURLResponse else {
            self = .unknown(nil)
            return
        }
        switch response.statusCode {
        case 400:
            self = .badRequest
        case 404:
            self = .notFound
        default:
            self = .unknown(response)
        }
    }

    var description: String {
        switch self {
        case .notFound:
            return ErrorMessages.NotFound
        case .networkProblem, .unknown:
            return ErrorMessages.ServerError
        case .requestFailed, .badRequest, .invalidData:
            return ErrorMessages.RequestFailed
        }
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return ErrorMessages.NotFound
        case .networkProblem, .unknown:
            return ErrorMessages.ServerError
        case .requestFailed, .badRequest, .invalidData:
            return ErrorMessages.RequestFailed
        }
    }
}

// MARK: - Menssages
extension APIError {
    struct ErrorMessages {
        static let ServerError = "Server Error. Please, try again later."
        static let NotFound = "Bad request error."
        static let RequestFailed = "Resquest failed. Please, try again later."
    }
}
