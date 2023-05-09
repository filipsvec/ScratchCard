//
//  Loadable.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation
import Combine

enum Loadable<T> {

    case notRequested
    case isLoading(last: T?, cancelBag: CancelBag)
    case loaded(T)
    case failed(Error)

    var value: T? {
        switch self {
        case let .loaded(value):
            return value
        case let .isLoading(last, _):
            return last
        default:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case let .failed(error):
            return error
        default:
            return nil
        }
    }
}

extension Loadable {
    
    mutating func setIsLoading(cancelBag: CancelBag) {
        self = .isLoading(last: value, cancelBag: cancelBag)
    }
}

extension Loadable: Equatable where T: Equatable {
    
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested):
            return true
        case let (.isLoading(lhsV, _), .isLoading(rhsV, _)):
            return lhsV == rhsV
        case let (.loaded(lhsV), .loaded(rhsV)):
            return lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default:
            return false
        }
    }
}
