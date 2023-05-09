//
//  BackendRepositoryTests.swift
//  ScratchCardTests
//
//  Created by Filip Svec on 09/05/2023.
//

import XCTest
import Combine
@testable import ScratchCard

final class BackendRepositoryTests: XCTestCase {
    
    typealias API = RealBackendRepository.API
    
    typealias Mock = RequestMocking.MockedResponse
    
    private let sut = RealBackendRepository(
        session: .mockedResponsesOnly,
        baseURL: "https://test.sk"
    )
    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    func test_activate() throws {
        let code = "1234"
        let data = MockActivationResponse(ios: "6.2")
        let exp = XCTestExpectation(description: "completion")
        let mock = try Mock(
            apiCall: API.activate(code),
            baseURL: sut.baseURL,
            result: .success(data),
            httpCode: 200
        )
        XCTAssertEqual(mock.url.query, "code=\(code)")
        
        RequestMocking.add(mock: mock)
        
        sut.activate(code: code)
            .sink {
                switch $0 {
                case .failure:
                    XCTFail()
                case .finished:
                    exp.fulfill()
                }
            } receiveValue: {
                XCTAssertTrue($0.activated)
            }
            .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
}

private struct MockActivationResponse: Codable {
    
    let ios: String
}
