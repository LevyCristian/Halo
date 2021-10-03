//
//  APIErrorTest.swift
//  HaloTests
//
//  Created by Levy Cristian on 03/10/21.
//

import Foundation
import Quick
import Nimble
@testable import Halo

class APIErrorTest: QuickSpec {

    private let defaultURL = URL(string: "http://localhost:8090/")!

    override func spec() {

        describe("APIError test") {

            context("Initialize test") {

                it("should handle error 400") {
                    let mockedResponse = HTTPURLResponse(url: self.defaultURL,
                                                         statusCode: 400,
                                                         httpVersion: nil,
                                                         headerFields: nil)
                    let error = APIError(response: mockedResponse)
                    expect(error.description).to(equal(APIError.badRequest.description))
                    expect(error.errorDescription).to(equal(APIError.ErrorMessages.RequestFailed))
                }

                it("should handle error 404") {
                    let mockedResponse = HTTPURLResponse(url: self.defaultURL,
                                                         statusCode: 404,
                                                         httpVersion: nil,
                                                         headerFields: nil)
                    let error = APIError(response: mockedResponse)
                    expect(error.description).to(equal(APIError.notFound.description))
                    expect(error.errorDescription).to(equal(APIError.ErrorMessages.NotFound))
                }
                it("should handle error default") {
                    let mockedResponse = HTTPURLResponse(url: self.defaultURL,
                                                         statusCode: 500,
                                                         httpVersion: nil,
                                                         headerFields: nil)
                    let error = APIError(response: mockedResponse)
                    expect(error.description).to(equal(APIError.unknown(mockedResponse).description))
                    expect(error.errorDescription).to(equal(APIError.ErrorMessages.ServerError))
                }

                it("should handle error unknown error") {
                    let error = APIError(response: nil)
                    expect(error.description).to(equal(APIError.unknown(nil).description))
                    expect(error.errorDescription).to(equal(APIError.ErrorMessages.ServerError))
                }
            }
        }
    }
}
