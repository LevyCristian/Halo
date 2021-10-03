//
//  URLRequest+Extensions.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

extension URLRequest {
    /// Set up the URLRequest to handle with JSON Content
    mutating func setJSONContentType() {
        setValue("application/json; charset=utf-8",
                 forHTTPHeaderField: "Content-Type")
    }

    /// Set a header value to URLRequest body
    /// - Parameters:
    ///   - httpHeaderField: A HTTP header Field key
    ///   - value: A value that follows the Key
    mutating func setHeader(for httpHeaderField: String, with value: String) {
        setValue(value, forHTTPHeaderField: httpHeaderField)
    }
}
