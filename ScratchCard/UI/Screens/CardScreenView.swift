//
//  CardScreenView.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import SwiftUI
import Combine

struct CardScreenView: View {
    
    @Environment(\.di) private var di: DIContainer
    
    @State private var cardState: Loadable<CardState> = .notRequested
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Card status:")
                    .bold()
                    .padding(.bottom, 5)
                
                cardStateView
                    .padding(.bottom, 20)
                
                HStack {
                    revealButton
                    
                    activateButton
                }
            }
            .padding()
        }
        .navigationTitle("Scratch card")
        .onReceive(cardStateUpdate) { cardState = $0 }
    }
}

private extension CardScreenView {
    
    var revealButton: some View {
        Button("Reveal") {
            di.appState[\.router].append(.reveal)
        }
        .primaryStyle()
    }
    
    var activateButton: some View {
        Button("Activate") {
            di.appState[\.router].append(.activation)
        }
        .primaryStyle()
    }
    
    var cardStateView: some View {
        Group {
            switch cardState {
            case .notRequested, .isLoading:
                ProgressView()
            case let .loaded(state):
                Text(state.localizedDescription)
            case let .failed(error):
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
        }
    }
}

private extension CardScreenView {
    
    var cardStateUpdate: AnyPublisher<Loadable<CardState>, Never> {
        di.appState.updates(for: \.userData.cardState)
    }
}

struct CardScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        CardScreenView()
    }
}
