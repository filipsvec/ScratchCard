//
//  AppEnvironment.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation
import UserNotifications

struct AppEnvironment {
    
    let container: DIContainer
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = Store(AppState())
        let session = configuredURLSession()
        let interactor = RealScratchCardInteractor(
            backendRepository: RealBackendRepository(
                session: session,
                baseURL: "https://api.o2.sk"
            ),
            codeGeneratorRepository: RealCodeGeneratorRepository(),
            notificationRepository: RealNotificationRepository(
                manager: UNUserNotificationCenter.current()
            ),
            appState: appState
        )
        return AppEnvironment(
            container: .init(
                appState: appState,
                interactors: .init(
                    scratchCardInteractor: interactor
                )
            )
        )
    }
}

private extension AppEnvironment {
    
    static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 10
        
        return URLSession(configuration: configuration)
    }
}
