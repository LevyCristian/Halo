//
//  EndpointProviderTest.swift
//  HaloTests
//
//  Created by Levy Cristian on 03/10/21.
//

import Foundation
@testable import Halo

enum EndpointProviderTest {
  case testeInvalidBaseURL
  case testDefaultEncodingWithGet(headers: [String: String], params: [String: Any])
  case testCompositeEncodingWithGet(headers: [String: String], params: [String: Any])
  case testJsonEncodingWithGet(headers: [String: String], params: [String: Any])
  case testDefaultEncodingWithPost(headers: [String: String], params: [String: Any])
  case testCompositeEncodingWithPost(headers: [String: String], params: [String: Any])
  case testJsonEncodingWithPost(headers: [String: String], params: [String: Any])
}

extension EndpointProviderTest: Endpoint {
  var cachePolicy: NSURLRequest.CachePolicy {
    .reloadIgnoringLocalCacheData
  }

  var base: String {
    switch self {
    case .testeInvalidBaseURL:
      return "There is an invalid url Base"
    default:
      return "http://localhost:8090/"
    }
  }

  var path: String {
    "/v1/teste"
  }

  var headers: [String: String]? {
    switch self {
    case .testDefaultEncodingWithGet(let headers, _):
    return headers

    case .testDefaultEncodingWithPost(let headers, _):
    return headers

    default:
      return [:]
    }
  }

  var params: [String: Any]? {
    switch self {
    case .testDefaultEncodingWithGet(_, let params),
         .testCompositeEncodingWithGet(_, let params),
         .testJsonEncodingWithGet(_, let params),
         .testDefaultEncodingWithPost(_, let params),
         .testCompositeEncodingWithPost(_, let params),
         .testJsonEncodingWithPost(_, let params):
      return params

    default:
      return [:]
    }
  }

  var parameterEncoding: ParameterEnconding {
    switch self {
    case .testDefaultEncodingWithGet, .testDefaultEncodingWithPost:
      return .defaultEncoding

    case .testCompositeEncodingWithGet, .testCompositeEncodingWithPost:
      return .compositeEncoding

    case .testJsonEncodingWithGet, .testJsonEncodingWithPost:
      return .jsonEncoding

    default:
      return .defaultEncoding
    }
  }

  var method: HTTPMethod {
    switch self {
    case .testDefaultEncodingWithGet,
         .testCompositeEncodingWithGet,
         .testJsonEncodingWithGet:
      return .get

    case .testDefaultEncodingWithPost,
         .testCompositeEncodingWithPost,
         .testJsonEncodingWithPost:
      return .post

    default:
      return .get
    }
  }
}
