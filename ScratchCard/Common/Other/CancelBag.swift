//
//  CancelBag.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Combine

final class CancelBag {
    
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
