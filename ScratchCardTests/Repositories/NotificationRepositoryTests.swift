//
//  NotificationRepositoryTests.swift
//  ScratchCardTests
//
//  Created by Filip Svec on 09/05/2023.
//

import XCTest
@testable import ScratchCard

final class NotificationRepositoryTests: XCTestCase {
        
    private lazy var sut = RealNotificationRepository(manager: mockManager)
    
    private lazy var mockManager = MockNotificationManager()
    
    override func tearDown() {
        mockManager.reset()
    }
    
    func test_notification() {
        let title = "title"
        let text = "text"
        
        sut.showNotification(title: title, text: text)
        
        delay()
        
        guard let request = mockManager.request else {
            XCTFail()
            return
        }
        XCTAssertEqual(request.content.title, title)
        XCTAssertEqual(request.content.subtitle, text)
        XCTAssertNil(request.trigger)
    }
}

private final class MockNotificationManager: NotificationManagerProtocol {
    
    private(set) var request: UNNotificationRequest?
    
    weak var delegate: UNUserNotificationCenterDelegate?
    
    func add(_ request: UNNotificationRequest) async throws {
        self.request = request
    }
    
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        true
    }
    
    func reset() {
        request = nil
    }
}
