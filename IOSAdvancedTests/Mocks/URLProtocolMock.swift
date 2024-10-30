import Foundation

class URLProtocolMock: URLProtocol {
    static var error: Error?
    static var handler: ((URLRequest) throws -> (Data, HTTPURLResponse))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        guard let handler = Self.handler else {
            fatalError("No Error or handler provided")
        }
        
        do {
            let (data, response) = try handler(self.request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
