//
//  DIContainer.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import SwiftUI

struct DIContainer: EnvironmentKey {
    
    let appState: Store<AppState>
    let interactors: Interactors
    
    init(appState: Store<AppState>, interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }
    
    static var defaultValue: Self {
        Self.default
    }
    
    private static let `default` = Self(
        appState: Store(AppState()),
        interactors: .stub
    )
}

extension EnvironmentValues {
    
    var di: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

extension DIContainer {
    
    struct Interactors {
        
        let scratchCardInteractor: ScratchCardInteractor
        
        static var stub: Self {
            .init(scratchCardInteractor: StubScratchCardInteractor())
        }
    }
    
    static var preview: Self {
        .init(
            appState: Store(.preview),
            interactors: .stub
        )
    }
}
