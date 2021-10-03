//
//  TVmazeAPIClientTest.swift
//  HaloTests
//
//  Created by Levy Cristian on 03/10/21.
//

import Foundation
import Quick
import Nimble
@testable import Halo

class TVmazeAPIClientTest: QuickSpec {
    var api = TVmazeAPIClient()

    private lazy var showsMockedData: Data? = {
        return loadMockData(from: .shows)
    }()

    private lazy var castsMockedData: Data? = {
        return loadMockData(from: .casts)
    }()

    private func mockURLSection() {
      MockURLProtocol.requestHandler = nil
      let configuration = URLSessionConfiguration.default
      configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])

      api = TVmazeAPIClient(configuration: configuration)
    }

    override func spec() {

      beforeEach {
        self.mockURLSection()
      }

      describe("Endpoints test") {

        context("on shows endpoint success") {

          it("should return shows") {

            guard let mockedData = self.showsMockedData else {
              return fail("Unable to retrive mocked data")
            }

            MockURLProtocol.requestHandler = { _ in
              (HTTPURLResponse(), mockedData)
            }
            waitUntil { done in
                self.api.getshows(at: 0) { result in
                switch result {
                case .success(let shows):
                  expect(shows).notTo(beEmpty())
                case .failure(let error):
                  fail("Unexpected error: \(error)")
                }
                done()
              }
            }
          }
        }

        context("on shows endpoint error") {

          it("should return an api error") {

            guard let mockedData = self.castsMockedData else {
              return fail("Unable to retrive mocked data")
            }

            MockURLProtocol.requestHandler = { _ in
              (HTTPURLResponse(), mockedData)
            }
            waitUntil { done in
                self.api.getshows(at: 0) { result in
                switch result {
                case .success:
                  fail("Unable behavior")
                case .failure(let error):
                  expect(error.description).to(equal(APIError.requestFailed.description))
                }
                done()
              }
            }
          }
        }
      }
    }
}
