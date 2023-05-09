//
//  RevealScreenView.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import SwiftUI
import Combine

struct RevealScreenView: View {
    
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
        .navigationTitle("Reveal card")
        .onReceive(cardStateUpdate) { cardState = $0 }
        .onDisappear {
            di.interactors.scratchCardInteractor.cancelReveal()
        }
    }
}
private extension RevealScreenView {
    
    func content(for state: CardState) -> some View {
        Group {
            switch state {
            case .activated, .scratched:
                Text("card is revealed")
            case .unused:
                Button("Reveal") {
                    di.interactors.scratchCardInteractor.revealCode()
                }
                .primaryStyle()
            }
        }
    }
}

private extension RevealScreenView {
    
    var cardStateUpdate: AnyPublisher<Loadable<CardState>, Never> {
        di.appState.updates(for: \.userData.cardState)
    }
}

struct RevealScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        RevealScreenView()
    }
}
