//
//  APIError.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

/// A wrapper for handle api type error
enum APIError: Error, ErrorDescriptable {
    /// Not found and object case
    case notFound
    ///Network problem case
    case networkProblem
    /// Bad request case
    case badRequest
    /// Request Failed case
    case requestFailed
    /// Invalid data case
    case invalidData
    /// Unknown case
    /// - Parameters:
    ///   - HTTPURLResponse: The specific HTTP response for that error
    case unknown(HTTPURLResponse?)
    
    /// Initialize a Api error of a failed response
    /// - Parameter response: The specific URL response for that error
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
    
    /// A string  describing what error occurred.
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
