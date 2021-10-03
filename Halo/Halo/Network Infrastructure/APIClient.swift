//
//  APIClient.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import UIKit

/// Comum implementation protocol to each API availiable
protocol APIClient {

    var session: URLSession { get }

    /// Perform a request of any type at a client API
    /// - Parameters:
    ///   - request: The request to be performed
    ///   - decode: A completion to receives a structure that conforms with the Decode protocol to be decoded into a type
    ///   - completion: A completion that handle with requests result
    func perform<T: Decodable>(with request: URLRequest,
                               decode: @escaping (Decodable) -> T?,
                               completion: ((Result<T, APIError>) -> Void)?)

}

extension APIClient {

    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void

    /// Create a connection to request endpoints data and convert it into a given type
    /// - Parameters:
    ///   - request: The request to be performed
    ///   - decodingType: A structure that conforms with the Decode protocoltype to be decoded
    ///   - completion: The task result completion handler
    /// - Returns: The request decoding task
    private func decodingTask<T: Decodable>(with request: URLRequest,
                                            decodingType: T.Type,
                                            completionHandler completion: JSONTaskCompletionHandler?) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion?(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let genericModel = try decoder.decode(decodingType, from: data)
                        completion?(genericModel, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion?(nil, .requestFailed)
                    }
                } else {
                    completion?(nil, .invalidData)
                }
            } else {
                completion?(nil, APIError(response: httpResponse))
            }
        }
        return task
    }

    func perform<T: Decodable>(with request: URLRequest,
                               decode: @escaping (Decodable) -> T?,
                               completion: ((Result<T, APIError>) -> Void)?) {
        let task = decodingTask(with: request, decodingType: T.self) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion?(Result.failure(error))
                    } else {
                        completion?(Result.failure(.requestFailed))
                    }
                    return
                }
                if let value = decode(json) {
                    completion?(.success(value))
                } else {
                    completion?(.failure(.requestFailed))
                }
            }
        }
        task.resume()
    }
}
