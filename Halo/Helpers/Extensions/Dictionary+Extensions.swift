//
//  Dictionary+Extensions.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

extension Dictionary {

    /// Convert a dictionary into a string allowed to be use as an URL
    /// - Returns: A absolute url string
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}
