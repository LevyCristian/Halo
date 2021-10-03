//
//  EndpointTest.swift
//  HaloTests
//
//  Created by Levy Cristian on 03/10/21.
//

import Foundation
import Quick
import Nimble
@testable import Halo

class EndpointTest: QuickSpec {

  override func spec() {

    context("Create a urlComponents") {

      it("with and invalid url base") {
        let endpoint = EndpointProviderTest.testeInvalidBaseURL
        expect(endpoint.urlComponents).to(beNil())
      }

      it("with default Encoding for Get") {
        var params = [String: Any]()
        params["name"] = "teste"
        params["appId"] = "com.teste.app"

        let endpoint = EndpointProviderTest.testDefaultEncodingWithGet(headers: [:],
                                                                         params: params)
        guard let urlComponent = endpoint.urlComponents else {
          return fail("Unable to retrieve urlComponent")
        }
        guard let queryItems = urlComponent.queryItems else {
          return fail("Unable to retrieve queryItems")
        }
        expect(queryItems.count).to(beGreaterThan(0))
      }

      it("with Composite Encoding for Get") {
        var query = [String: Any]()
        query["name"] = "teste"
        query["appId"] = "com.teste.app"

        var params = [String: Any]()
        params["query"] = query

        let endpoint = EndpointProviderTest.testCompositeEncodingWithGet(headers: [:],
                                                                         params: params)
        guard let urlComponent = endpoint.urlComponents else {
          return fail("Unable to retrieve urlComponent")
        }
        guard let queryItems = urlComponent.queryItems else {
          return fail("Unable to retrieve queryItems")
        }
        expect(queryItems.count).to(beGreaterThan(0))
      }

      it("with Json Encoding for Get") {
        var params = [String: Any]()
        params["name"] = "teste"
        params["appId"] = "com.teste.app"

        let endpoint = EndpointProviderTest.testJsonEncodingWithGet(headers: [:],
                                                                    params: params)
        guard let urlComponent = endpoint.urlComponents else {
          return fail("Unable to retrieve urlComponent")
        }
        expect(urlComponent.queryItems?.isEmpty).to(beTrue())
      }
    }

    context("Create a URLRequest") {

      it("with a urlComponents nil") {
        let endpoint = EndpointProviderTest.testeInvalidBaseURL

        expect(endpoint.request).to(beNil())
      }

      it("with a header for get") {
        var params = [String: String]()
        params["name"] = "teste"
        params["appId"] = "com.teste.app"

        let endpoint = EndpointProviderTest.testDefaultEncodingWithGet(headers: params,
                                                                         params: params)
        guard let request = endpoint.request else {
          return fail("Unable to retrieve the request")
        }
        guard let headerFields = request.allHTTPHeaderFields else {
          return fail("Unable to retrieve all http header fields")
        }
        expect(headerFields.count).to(beGreaterThan(0))
      }
    }

    context("parameter Encoding") {

      it("with default Encoding for Post") {
        var params = [String: String]()
        params["name"] = "teste"
        params["appId"] = "com.teste.app"

        let endpoint = EndpointProviderTest.testDefaultEncodingWithPost(headers: params,
                                                                         params: params)
        guard let request = endpoint.request else {
          return fail("Unable to retrieve the request")
        }
        expect(request.httpBody).notTo(beNil())
      }

      it("with Composite Encoding for Post") {
        var body = [String: String]()
        body["name"] = "teste"
        body["appId"] = "com.teste.app"

        var params = [String: Any]()
        params["body"] = body

        let endpoint = EndpointProviderTest.testCompositeEncodingWithPost(headers: body,
                                                                         params: params)
        guard let request = endpoint.request else {
          return fail("Unable to retrieve the request")
        }
        expect(request.httpBody).notTo(beNil())
      }

      it("with JSON Encoding for Post") {
        var params = [String: String]()
        params["name"] = "teste"
        params["appId"] = "com.teste.app"

        let endpoint = EndpointProviderTest.testJsonEncodingWithPost(headers: params,
                                                                         params: params)
        guard let request = endpoint.request else {
          return fail("Unable to retrieve the request")
        }
        expect(request.httpBody).notTo(beNil())
      }
    }
  }
}
