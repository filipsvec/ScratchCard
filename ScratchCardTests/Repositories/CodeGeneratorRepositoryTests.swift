//
//  CodeGeneratorRepositoryTests.swift
//  ScratchCardTests
//
//  Created by Filip Svec on 09/05/2023.
//

import XCTest
import Combine
@testable import ScratchCard

final class CodeGeneratorRepositoryTests: XCTestCase {
    
    private lazy var sut = RealCodeGeneratorRepository()
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        subscriptions = Set<AnyCancellable>()
    }
    
    func test_code() {
        let exp = XCTestExpectation(description: "completion")
        
        sut.generateCode()
            .sink {
                switch $0 {
                case .failure:
                    XCTFail()
                case .finished:
                    exp.fulfill()
                }
            } receiveValue: {
                XCTAssertNotNil(UUID(uuidString: $0))
            }
            .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 5)
    }
}
