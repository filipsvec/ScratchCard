//
//  RequestMocking.swift
//  ScratchCardTests
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation

extension URLSession {
    
    static var mockedResponsesOnly: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [
            RequestMocking.self,
            RequestBlocking.self
        ]
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        return URLSession(configuration: configuration)
    }
}

final class RequestMocking: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        mock(for: request) != nil
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        false
    }

    override func startLoading() {
        guard let mock = RequestMocking.mock(for: request),
              let url = request.url else {
            return
        }
        let response = mock.customResponse ??
            HTTPURLResponse(
                url: url,
                statusCode: mock.httpCode,
                httpVersion: "HTTP/1.1",
                headerFields: mock.headers
            )
        
        guard let response = response else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
            guard let self = self else {
                return
            }
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            switch mock.result {
            case let .success(data):
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            case let .failure(error):
                let failure = NSError(
                    domain: NSURLErrorDomain, code: 1,
                    userInfo: [NSUnderlyingErrorKey: error]
                )
                self.client?.urlProtocol(self, didFailWithError: failure)
            }
        }
    }

    override func stopLoading() {
        
    }
}

extension RequestMocking {
    
    static private var mocks: [MockedResponse] = []
    
    static func add(mock: MockedResponse) {
        mocks.append(mock)
    }
    
    static func removeAllMocks() {
        mocks.removeAll()
    }
    
    static private func mock(for request: URLRequest) -> MockedResponse? {
        mocks.first { $0.url == request.url }
    }
}

private class RequestBlocking: URLProtocol {
    
    enum Error: Swift.Error {
        case requestBlocked
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        DispatchQueue(label: "test_queue").async {
            self.client?.urlProtocol(self, didFailWithError: Error.requestBlocked)
        }
    }
    
    override func stopLoading() {
        
    }
}
