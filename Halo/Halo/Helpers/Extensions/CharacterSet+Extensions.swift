//
//  CharacterSet+Extensions.swift
//  Halo
//
//  Created by Levy Cristian on 02/10/21.
//

import Foundation

extension CharacterSet {
    /// The collecton of character allowed to a URL
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
