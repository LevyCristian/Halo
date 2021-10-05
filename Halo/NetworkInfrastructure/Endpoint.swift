//
//  Endpoint.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

/// Comum implementation protocol that contains each Endpoint essential information of an API
protocol Endpoint {

    /// Api base url
    var base: String { get }
    /// Endpoints route path
    var path: String { get }
    /// Endpoints headers
    var headers: [String: String]? { get }
    /// Endpoint params
    var params: [String: Any]? { get }
    /// Endpoint type of parameter Encoding
    var parameterEncoding: ParameterEnconding { get }
    /// Endpoint HTTP method
    var method: HTTPMethod { get }
}

extension Endpoint {

    /// Avaliable components used by the Endpoint URL
    var urlComponents: URLComponents? {
        guard var components = URLComponents(string: base) else {
            return nil
        }
        components.path = path
        var queryItems = [URLQueryItem]()

        switch parameterEncoding {
        case .defaultEncoding:
            if let params = params, method == .get {
                queryItems.append(contentsOf: params.map {
                    URLQueryItem(name: "\($0)", value: "\($1)")
                })
            }

        case .compositeEncoding:
            if let params = params,
               let queryParams = params["query"] as? [String: Any] {
                queryItems.append(contentsOf: queryParams.map {
                    URLQueryItem(name: "\($0)", value: "\($1)")
                })
            }

        case .jsonEncoding:
            break
        }

        components.queryItems = queryItems
        return components
    }

    /// The formatted URL request of EndPoints
    var request: URLRequest? {
        guard let url = urlComponents?.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = .useProtocolCachePolicy
        if let headers = headers {
            for (key, value) in headers {
                request.setHeader(for: key, with: value)
            }
        }

        guard let params = params, method != .get else {
            return request
        }

        switch parameterEncoding {
        case .defaultEncoding:
            request.httpBody = params.percentEscaped().data(using: .utf8)

        case .jsonEncoding:
            request.setJSONContentType()
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData

        case .compositeEncoding:
            if let bodyParams = params["body"] as? [String: Any] {
                request.setJSONContentType()
                let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams)
                request.httpBody = jsonData
            }
        }
        return request
    }

}

/// Avaliables HTTP methods to be used by EndPoints
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

/// Avaliables Enconding types to be use by EndPoints
enum ParameterEnconding {
    case defaultEncoding
    case jsonEncoding
    case compositeEncoding
}
