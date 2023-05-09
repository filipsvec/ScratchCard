//
//  ContentView.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @Environment(\.di) private var di: DIContainer
    
    @State private var router: [Route] = []
    
    @State private var alertMessage: String?
    
    var body: some View {
        NavigationStack(path: routerBinding) {
            CardScreenView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .reveal:
                        RevealScreenView()
                    case .activation:
                        ActivationScreenView()
                    }
                }
        }
        .onReceive(routerUpdate) { router = $0 }
        .onReceive(alertMessageUpdate) { alertMessage = $0 }
        .alert(alertMessage ?? "", isPresented: showAlertBinding) {
            Button("OK", role: .cancel) {
                alertMessage = nil
            }
        }
    }
}

private extension ContentView {
    
    var routerUpdate: AnyPublisher<[Route], Never> {
        di.appState.updates(for: \.router)
    }
    
    var routerBinding: Binding<[Route]> {
        $router.dispatched(to: di.appState, \.router)
    }
    
    var alertMessageUpdate: AnyPublisher<String?, Never> {
        di.appState.updates(for: \.userData.alertMessage)
    }
    
    var showAlertBinding: Binding<Bool> {
        Binding {
            alertMessage != nil
        } set: { _ in
            di.appState[\.userData.alertMessage] = nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
