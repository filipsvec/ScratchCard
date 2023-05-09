//
//  ScratchCardInteractor.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation
import Combine
import SwiftUI

protocol ScratchCardInteractor {
    
    func revealCode()
    
    func cancelReveal()
    
    func activate(_ code: String)
}

struct RealScratchCardInteractor: ScratchCardInteractor {
    
    private let backendRepository: BackendRepository
    private let codeGeneratorRepository: CodeGeneratorRepository
    private let notificationRepository: NotificationRepository
    private let appState: Store<AppState>
    
    init(
        backendRepository: BackendRepository,
        codeGeneratorRepository: CodeGeneratorRepository,
        notificationRepository: NotificationRepository,
        appState: Store<AppState>)
    {
        self.backendRepository = backendRepository
        self.codeGeneratorRepository = codeGeneratorRepository
        self.notificationRepository = notificationRepository
        self.appState = appState
    }
    
    func revealCode() {
        let cancelBag = CancelBag()
        
        appState[\.userData.cardState].setIsLoading(cancelBag: cancelBag)
        
        codeGeneratorRepository.generateCode()
            .sink {
                appState[\.userData.cardState] = .loaded(.scratched($0))
            }
            .store(in: cancelBag)
    }
    
    func cancelReveal() {
        guard case let .isLoading(lastValue, bag) = appState[\.userData.cardState],
              case .unused = lastValue else {
            return
        }
        bag.cancel()
        appState[\.userData.cardState] = .loaded(.unused)
    }
    
    func activate(_ code: String) {
        let cancelBag = CancelBag()
        
        appState[\.userData.cardState].setIsLoading(cancelBag: cancelBag)
        
        backendRepository.activate(code: code)
            .sink {
                if case let .failure(error) = $0 {
                    appState[\.userData.cardState] = .loaded(.scratched(code))
                    appState[\.userData.alertMessage] = error.localizedDescription
                }
            } receiveValue: { response in
                if response.activated {
                    appState[\.userData.cardState] = .loaded(.activated(code))
                } else {
                    appState[\.userData.cardState] = .loaded(.scratched(code))
                    dispatchActivationFailedNotification()
                }
            }
            .store(in: cancelBag)
    }
}

private extension RealScratchCardInteractor {
    
    func dispatchActivationFailedNotification() {
        notificationRepository.showNotification(
            title: "Activation failed",
            text: "Unable to activate code"
        )
    }
}

struct StubScratchCardInteractor: ScratchCardInteractor {
    
    func revealCode() {
        
    }
    
    func cancelReveal() {
        
    }
    
    func activate(_ code: String) {
        
    }
}
