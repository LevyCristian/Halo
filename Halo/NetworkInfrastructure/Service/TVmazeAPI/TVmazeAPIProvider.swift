//
//  TVmazeAPIProvider.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

/// A provider that contains each Endpoint available at TVmaze API and its specific definitions
enum TVmazeAPIProvider {
    /// Gets shows by a page
    /// - Parameters:
    ///   - page: The current api page
    case shows(Int)
}

extension TVmazeAPIProvider: Endpoint {
    var base: String {
        "https://api.tvmaze.com"
    }

    var path: String {
        switch self {
        case .shows:
            return "/shows"
        }
    }

    var headers: [String: String]? {
        return [:]
    }

    var params: [String: Any]? {
        switch self {
        case .shows(let page):
            return ["page": page]
        }
    }

    var parameterEncoding: ParameterEnconding {
        switch self {
        case .shows:
            return .defaultEncoding
        }
    }

    var method: HTTPMethod {
        switch self {
        case .shows:
            return .get
        }
    }
}
