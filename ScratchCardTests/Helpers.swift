//
//  Helpers.swift
//  ScratchCardTests
//
//  Created by Filip Svec on 09/05/2023.
//

import XCTest

extension XCTestCase {
    
    func delay(_ seconds: Int = 1) {
        let exp = XCTestExpectation(description: "delay")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}

extension NSError {
    
    static var test: NSError {
        NSError(
            domain: "test",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "error"]
        )
    }
}
