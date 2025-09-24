//
//  NetworkParsingTests.swift
//  APIExplorerUITests
//
//  Created by Mehmet Ali Sevdinoğlu on 25.09.2025.
//

import Foundation
import XCTest
@testable import APIExplorer

// Mock URLProtocol
final class MockURLProtocol: URLProtocol {
    static var stub: (Data, Int) = (Data(), 200)

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        let (data, status) = Self.stub
        let resp = HTTPURLResponse(url: request.url!,
                                   statusCode: status,
                                   httpVersion: nil,
                                   headerFields: nil)!
        client?.urlProtocol(self, didReceive: resp, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

// Yardımcı fonksiyon → mock session
private func makeSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
}

// Asıl testler
final class NetworkParsingTests: XCTestCase {
    func test_success_parsesCharacters() async throws {
        // 1) Stub JSON
        let json = """
        {"info":{"count":2,"pages":1,"next":null,"prev":null},
         "results":[{"id":1,"name":"Rick","status":"Alive","species":"Human","image":"https://example.com/r.png"},
                    {"id":2,"name":"Morty","status":"Alive","species":"Human","image":"https://example.com/m.png"}]}
        """.data(using: .utf8)!
        MockURLProtocol.stub = (json, 200)

        // 2) Service (mock session)
        let service = CharacterService(network: NetworkService(session: makeSession()))
        let resp = try await service.fetch(page: 1, name: nil)

        XCTAssertEqual(resp.results.count, 2)
        XCTAssertEqual(resp.results.first?.name, "Rick")
    }

    func test_httpError_propagates() async {
        MockURLProtocol.stub = (Data(), 500)
        let service = CharacterService(network: NetworkService(session: makeSession()))
        do {
            _ = try await service.fetch(page: 1, name: nil)
            XCTFail("500 bekleniyordu")
        } catch {
            // Geçti
            XCTAssertTrue(true)
        }
    }
}
