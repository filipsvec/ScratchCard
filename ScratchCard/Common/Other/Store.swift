//
//  Store.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import SwiftUI
import Combine

typealias Store<State> = CurrentValueSubject<State, Never>

extension Store {
    
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get {
            value[keyPath: keyPath]
        }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }
    
    func updates<T>(for keyPath: KeyPath<Output, T>) -> AnyPublisher<T, Failure> where T: Equatable {
        map(keyPath)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

extension Binding where Value: Equatable {
    
    typealias ValueClosure = (Value) -> Void
    
    func onChange(_ perform: @escaping ValueClosure) -> Self {
        Self {
            wrappedValue
        } set: {
            if wrappedValue != $0 {
                wrappedValue = $0
            }
            perform($0)
        }
    }
    
    func dispatched<T>(
        to state: Store<T>,
        _ keyPath: WritableKeyPath<T, Value>
    ) -> Self {
        onChange { state[keyPath] = $0 }
    }
}
