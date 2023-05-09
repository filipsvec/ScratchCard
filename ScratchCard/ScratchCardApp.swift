//
//  ScratchCardApp.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import SwiftUI

@main
struct ScratchCardApp: App {
    
    @State private var container = AppEnvironment.bootstrap().container
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.di, container)
        }
    }
}
