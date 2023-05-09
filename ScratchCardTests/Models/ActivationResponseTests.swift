//
//  ActivationResponseTests.swift
//  ScratchCardTests
//
//  Created by Filip Svec on 09/05/2023.
//

import XCTest
@testable import ScratchCard

final class ActivationResponseTests: XCTestCase {
    
    private let decoder = JSONDecoder()

    func test_activatedResponseDecoding() throws {
        let data = try mockData(with: "6.1.1")
        let output = try decoder.decode(ActivationResponse.self, from: data)
        
        XCTAssertEqual(output.activated, true)
    }
    
    func test_notActivatedResponseDecoding() throws {
        let data = try mockData(with: "6.1")
        let output = try decoder.decode(ActivationResponse.self, from: data)
        
        XCTAssertEqual(output.activated, false)
    }
}

private extension ActivationResponseTests {
    
    func mockData(with version: String) throws -> Data {
        let mock = ["ios": version]
        return try JSONSerialization.data(withJSONObject: mock)
    }
}
