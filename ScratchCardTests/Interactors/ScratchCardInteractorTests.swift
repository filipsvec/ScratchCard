//
//  ScratchCardInteractorTests.swift
//  ScratchCardTests
//
//  Created by Filip Svec on 09/05/2023.
//

import XCTest
import Combine
@testable import ScratchCard

final class ScratchCardInteractorTests: XCTestCase {
    
    private lazy var backendRepository = MockBackendRepository(
        session: .mockedResponsesOnly,
        baseURL: "https://test.sk"
    )
    private lazy var codeGeneratorRepository = MockCodeGeneratorRepository()
    private lazy var notificationRepository = MockNotificationRepository()
    private lazy var appState = Store(AppState())
    
    private lazy var sut = RealScratchCardInteractor(
        backendRepository: backendRepository,
        codeGeneratorRepository: codeGeneratorRepository,
        notificationRepository: notificationRepository,
        appState: appState
    )
    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDown() {
        backendRepository.reset()
        notificationRepository.reset()
        
        appState[\.userData.cardState] = .loaded(.unused)
        appState[\.userData.alertMessage] = nil
    }
    
    func test_successfulReveal() {
        sut.revealCode()
        
        guard case .isLoading = appState[\.userData.cardState] else {
            XCTFail()
            return
        }
        delay()
        
        guard case let .loaded(state) = appState[\.userData.cardState],
              case let .scratched(code) = state,
              code == codeGeneratorRepository.code else {
            XCTFail()
            return
        }
        XCTAssertNil(appState[\.userData.alertMessage])
    }
    
    func test_revealCancellation() {
        let cancelBag = CancelBag()
        
        appState[\.userData.cardState] = .isLoading(last: .unused, cancelBag: cancelBag)
        
        sut.cancelReveal()
        
        XCTAssertEqual(appState[\.userData.cardState], .loaded(.unused))
    }
    
    func test_successfulActivation() {
        let code = "1234"
        
        sut.activate(code)

        guard case .isLoading = appState[\.userData.cardState] else {
            XCTFail()
            return
        }
        delay()

        guard case let .loaded(state) = appState[\.userData.cardState],
              case let .activated(code) = state,
              code == codeGeneratorRepository.code else {
            XCTFail()
            return
        }
        XCTAssertNil(appState[\.userData.alertMessage])
        XCTAssertNil(notificationRepository.notification)
    }
    
    func test_unsuccessfulActivation() {
        let codeInput = "1234"
        
        backendRepository.activated = false
        
        sut.activate(codeInput)

        guard case .isLoading = appState[\.userData.cardState] else {
            XCTFail()
            return
        }
        delay()

        guard case let .loaded(state) = appState[\.userData.cardState],
              case let .scratched(code) = state,
              code == codeInput else {
            XCTFail()
            return
        }
        XCTAssertNil(appState[\.userData.alertMessage])
        
        guard let notification = notificationRepository.notification else {
            XCTFail()
            return
        }
        XCTAssertEqual(notification.title, "Activation failed")
        XCTAssertEqual(notification.text, "Unable to activate code")
    }
    
    func test_failedActivationOperation() {
        let codeInput = "1234"
        
        backendRepository.success = false
        
        sut.activate(codeInput)

        guard case .isLoading = appState[\.userData.cardState] else {
            XCTFail()
            return
        }
        delay()

        guard case let .loaded(state) = appState[\.userData.cardState],
              case let .scratched(code) = state,
              code == codeInput else {
            XCTFail()
            return
        }
        XCTAssertNotNil(appState[\.userData.alertMessage])
        XCTAssertNil(notificationRepository.notification)
    }
}

private final class MockNotificationRepository: NotificationRepository {
    
    struct Notification {
        let title: String
        let text: String
    }
    
    private(set) var notification: Notification?
    
    func showNotification(title: String, text: String) {
        notification = .init(title: title, text: text)
    }
    
    func reset() {
        notification = nil
    }
}

private class MockBackendRepository: BackendRepository {
    
    let session: URLSession
    
    let baseURL: String
    
    var activated = true
    
    var success = true
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func activate(code: String) -> AnyPublisher<ActivationResponse, Error> {
        Future { [success, activated] promise in
            DispatchQueue.main.async {
                if success {
                    let response = ActivationResponse(activated: activated)
                    promise(.success(response))
                } else {
                    promise(.failure(NSError.test))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func reset() {
        activated = true
        success = true
    }
}

private class MockCodeGeneratorRepository: CodeGeneratorRepository {
    
    var code = "1234"
    
    func generateCode() -> AnyPublisher<String, Never> {
        Future { [code] promise in
            DispatchQueue.main.async {
                promise(.success(code))
            }
        }
        .eraseToAnyPublisher()
    }
}
