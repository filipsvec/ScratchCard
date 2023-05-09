//
//  ActivationScreenView.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import SwiftUI
import Combine

struct ActivationScreenView: View {
    
    @Environment(\.di) private var di: DIContainer
    
    @State private var cardState: Loadable<CardState> = .notRequested
    
    var body: some View {
        ScrollView {
            VStack {
                switch cardState {
                case .notRequested, .isLoading:
                    ProgressView()
                case let .failed(error):
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                case let .loaded(state):
                    content(for: state)
                }
            }
            .padding()
        }
        .navigationTitle("Activate card")
        .onReceive(cardStateUpdate) { cardState = $0 }
    }
}

private extension ActivationScreenView {
    
    func content(for state: CardState) -> some View {
        Group {
            switch state {
            case .activated:
                Text("card is activated")
            case let .scratched(code):
                Button("Activate") {
                    di.interactors.scratchCardInteractor.activate(code)
                }
                .primaryStyle()
            case .unused:
                Text("card is not revealed yet")
            }
        }
    }
}

private extension ActivationScreenView {
    
    var cardStateUpdate: AnyPublisher<Loadable<CardState>, Never> {
        di.appState.updates(for: \.userData.cardState)
    }
}

struct ActivationScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        ActivationScreenView()
    }
}
