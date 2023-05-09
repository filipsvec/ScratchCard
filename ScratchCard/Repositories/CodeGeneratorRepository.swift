//
//  CodeGeneratorRepository.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation
import Combine

protocol CodeGeneratorRepository {

    func generateCode() -> AnyPublisher<String, Never>
}

struct RealCodeGeneratorRepository: CodeGeneratorRepository {
    
    func generateCode() -> AnyPublisher<String, Never> {
        Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                let uuid = UUID().uuidString
                promise(.success(uuid))
            }
        }
        .eraseToAnyPublisher()
    }
}
