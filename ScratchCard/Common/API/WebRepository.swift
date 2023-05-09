//
//  WebRepository.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation
import Combine

protocol WebRepository {
    
    var session: URLSession { get }
    
    var baseURL: String { get }
}

extension WebRepository {
    
    func call<T>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<T, Error> where T: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            
            return session
                .dataTaskPublisher(for: request)
                .requestJSON(httpCodes: httpCodes)
        } catch let error {
            return Fail<T, Error>(error: error)
                .eraseToAnyPublisher()
        }
    }
}

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    
    func requestData(httpCodes: HTTPCodes = .success) -> AnyPublisher<Data, Error> {
        return tryMap {
            assert(!Thread.isMainThread)
            guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                throw APIError.unexpectedResponse
            }
            guard httpCodes.contains(code) else {
                throw APIError.httpCode(code)
            }
            return $0.0
        }
        .extractUnderlyingError()
        .eraseToAnyPublisher()
    }
}

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    
    func requestJSON<T>(httpCodes: HTTPCodes) -> AnyPublisher<T, Error> where T: Decodable {
        requestData(httpCodes: httpCodes)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    
    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }
}

private extension Error {
    
    var underlyingError: Error? {
        let nsError = self as NSError
        
        if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet {
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}
