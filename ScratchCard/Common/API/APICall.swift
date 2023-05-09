//
//  APICall.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation

protocol APICall {
    
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    
    func body() throws -> Data?
}

enum APIError: Error {
    
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
}

extension APIError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .httpCode(let code):
            return "Request failed with code \(code)"
        case .unexpectedResponse:
            return "Unexpected response from the server"
        }
    }
}

extension APICall {
    
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    
    static let success = 200 ..< 300
}
