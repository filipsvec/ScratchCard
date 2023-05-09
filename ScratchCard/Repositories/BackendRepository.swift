//
//  BackendRepository.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation
import Combine

protocol BackendRepository: WebRepository {
    
    func activate(code: String) -> AnyPublisher<ActivationResponse, Error>
}

struct RealBackendRepository: BackendRepository {
    
    let session: URLSession
    
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func activate(code: String) -> AnyPublisher<ActivationResponse, Error> {
        call(endpoint: API.activate(code))
    }
}

extension RealBackendRepository {
    
    enum API {
        case activate(String)
    }
}

extension RealBackendRepository.API: APICall {
    
    var path: String {
        switch self {
        case let .activate(code):
            return "/version?code=\(code)"
        }
    }
    
    var method: String {
        switch self {
        case .activate:
            return "GET"
        }
    }
    
    var headers: [String: String]? {
        nil
    }
    
    func body() throws -> Data? {
        nil
    }
}
