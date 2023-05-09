//
//  ActivationResponse.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation

struct ActivationResponse: Decodable {
    
    let activated: Bool
}

extension ActivationResponse {
    
    private struct C {
        static let activationThreshold = "6.1.0"
    }
    
    private enum CodingKeys: CodingKey {
        case ios
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(String.self, forKey: .ios)
        
        activated = value.versionCompare(C.activationThreshold) == .orderedDescending
    }
}
