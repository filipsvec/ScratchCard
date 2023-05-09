//
//  StringExtensionTests.swift
//  ScratchCardTests
//
//  Created by Filip Svec on 09/05/2023.
//

import XCTest
@testable import ScratchCard

final class StringExtensionTests: XCTestCase {

    func test_versionCompare() {
        XCTAssertEqual("5.0".versionCompare("6.1.0"), .orderedAscending)
        XCTAssertEqual("6.0".versionCompare("6.1.0"), .orderedAscending)
        XCTAssertEqual("6.1".versionCompare("6.1.0"), .orderedAscending)
        XCTAssertEqual("6.1.0".versionCompare("6.1.0"), .orderedSame)
        XCTAssertEqual("6.1.1".versionCompare("6.1.0"), .orderedDescending)
        XCTAssertEqual("6.2".versionCompare("6.1.0"), .orderedDescending)
        XCTAssertEqual("7".versionCompare("6.1.0"), .orderedDescending)
    }
}
