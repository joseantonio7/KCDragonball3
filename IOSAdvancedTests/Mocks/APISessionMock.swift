
import Foundation
@testable import IOSAdvanced

struct APISessionMock: APISessionContract {
    static var shared: APISessionContract = APISession()
    
    private let session: URLSession
    private let requestInterceptors: [APIRequestInterceptor]
    
    init(handler:((URLRequest) throws -> (Data, HTTPURLResponse))? = nil, requestInterceptors: [APIRequestInterceptor] = [AuthenticationRequestInterceptor(dataSource: SecureDataStorageMock())] ) {
        self.requestInterceptors = requestInterceptors
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        self.session = URLSession(configuration: configuration)
        
    }
    
    func request<Request: APIRequest >(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            var request = try apiRequest.getRequest()
            
            requestInterceptors.forEach { $0.intercept(request: &request) }
            
            session.dataTask(with: request) { data, response, error in
                if let error {
                    return completion(.failure(error))
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    return completion(.failure(APIErrorResponse.network(apiRequest.path, code: 0)))
                }
                if httpResponse.statusCode != 200 {
                    return completion(.failure(APIErrorResponse.network(apiRequest.path, code: httpResponse.statusCode)))
                }
                return completion(.success(data ?? Data()))
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
