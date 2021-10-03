//
//  QuickSpec+Extension.swift
//  HaloTests
//
//  Created by Levy Cristian on 03/10/21.
//

import Foundation
import Quick

extension QuickSpec {
    func loadMockData(from: RequestType) -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: "\(from.rawValue)Mock", ofType: "json") else {
            return nil
        }

        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        return jsonData
    }

    func decodeMockedData<T: Decodable>(type: T.Type, from: RequestType) -> T? {
        guard let data = loadMockData(from: from) else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(type, from: data)
            return result
        } catch {
            return nil
        }
    }
}

enum RequestType: String {
    case shows
    case casts
}
