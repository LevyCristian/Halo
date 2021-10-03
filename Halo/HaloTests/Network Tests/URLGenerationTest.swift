//
//  URLGenerationTest.swift
//  HaloTests
//
//  Created by Levy Cristian on 03/10/21.
//

import Foundation
import Quick
import Nimble
@testable import Halo

class URLGenerationTest: QuickSpec {

  private var dictionaryMock = [String: Any]()

  override func spec() {

    afterEach {
      self.dictionaryMock = [:]
    }

    context("Convert a dictionary into a string with percentEscaped") {

      it("urlQuery value allowed") {
        self.dictionaryMock["name"] = "teste"
        self.dictionaryMock["appId"] = "com.teste.app"

        let possibleEscapedParameters = ["name=teste&appId=com.teste.app", "appId=com.teste.app&name=teste"]

        expect(possibleEscapedParameters.contains(self.dictionaryMock.percentEscaped())).to(beTrue())
      }

      it("urlQuery value allowed with nil value") {
        self.dictionaryMock["name"] = "teste"
        self.dictionaryMock["appId"] = "com.teste.app"
        self.dictionaryMock["recordId"] = nil

        let possibleEscapedParameters = ["name=teste&appId=com.teste.app", "appId=com.teste.app&name=teste"]

        expect(possibleEscapedParameters.contains(self.dictionaryMock.percentEscaped())).to(beTrue())
      }

      it("urlQuery value allowed with Empty paramters") {
        let percentEscapedParameters = self.dictionaryMock.percentEscaped()

        expect(percentEscapedParameters.isEmpty).to(beTrue())
      }

      it("urlQuery value allowed with a single paramter") {
        self.dictionaryMock["name"] = "teste"
        let percentEscapedParameters = self.dictionaryMock.percentEscaped()

        expect(percentEscapedParameters).to(equal("name=teste"))
      }
    }

    context("URLRequest SetJsonContentType") {
      it("not to be nil") {
        guard let url = URL(string: "http://localhost:8090/index.html") else {
            return fail("Unable to create a URL")
        }
        var urlRequest = URLRequest(url: url)

        urlRequest.setJSONContentType()
        let allHeaderFields = urlRequest.allHTTPHeaderFields

        expect(allHeaderFields?["Content-Type"]).notTo(beNil())
      }

      it("to be nil") {
        guard let url = URL(string: "http://localhost:8090/index.html") else {
            return fail("Unable to create a URL")
        }
        let urlRequest = URLRequest(url: url)

        let allHeaderFields = urlRequest.allHTTPHeaderFields

        expect(allHeaderFields?["Content-Type"]).to(beNil())
      }
    }

    context("URLRequest setHeader") {
      it("not to be nil") {
        guard let url = URL(string: "http://localhost:8090/index.html") else {
            return fail("Unable to create a URL")
        }
        var urlRequest = URLRequest(url: url)

        urlRequest.setHeader(for: "cache", with: "Cache-Allowed")
        let allHeaderFields = urlRequest.allHTTPHeaderFields

        expect(allHeaderFields?["cache"]).notTo(beNil())
      }
    }
  }
}
