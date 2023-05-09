//
//  CardState.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation

enum CardState: Equatable {
    case unused
    case scratched(String)
    case activated(String)
}

extension CardState {
    
    var localizedDescription: String {
        switch self {
        case .unused:
            return "not revealed"
        case let .scratched(code):
            return "revealed\n\(code)"
        case let .activated(code):
            return "activated\n\(code)"
        }
    }
}
