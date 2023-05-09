//
//  AppState.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation

struct AppState: Equatable {
    
    struct UserData: Equatable {
        var cardState: Loadable<CardState> = .loaded(.unused)
        var alertMessage: String?
    }
    
    var userData = UserData()
    
    var router: [Route] = []
}

extension AppState {
    
    static var preview = AppState()
}
