//
//  LoadableTests.swift
//  ScratchCardTests
//
//  Created by Filip Svec on 09/05/2023.
//

import XCTest
@testable import ScratchCard

final class LoadableTests: XCTestCase {

    func test_equality() {
        let possibleValues: [Loadable<Int>] = [
            .notRequested,
            .isLoading(last: nil, cancelBag: CancelBag()),
            .isLoading(last: 9, cancelBag: CancelBag()),
            .loaded(5),
            .loaded(6),
            .failed(NSError.test)
        ]
        possibleValues.enumerated().forEach { (index1, value1) in
            possibleValues.enumerated().forEach { (index2, value2) in
                if index1 == index2 {
                    XCTAssertEqual(value1, value2)
                } else {
                    XCTAssertNotEqual(value1, value2)
                }
            }
        }
    }
}
