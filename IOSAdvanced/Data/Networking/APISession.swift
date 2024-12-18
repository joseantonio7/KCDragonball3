import Foundation

protocol APISessionContract {
    func request<Request: APIRequest >(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

struct APISession: APISessionContract {
    static var shared: APISessionContract = APISession()
    
    private let session: URLSession
    private let requestInterceptors: [APIRequestInterceptor]
    
    init(urlsession: URLSession = URLSession(configuration: .default), requestInterceptors: [APIRequestInterceptor] = [AuthenticationRequestInterceptor()]) {
        self.requestInterceptors = requestInterceptors
        self.session = urlsession
        
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
                    return completion(.failure(APIErrorResponse.init(url: "", statusCode: httpResponse.statusCode, message: "\(httpResponse.statusCode)")))
                }
                return completion(.success(data ?? Data()))
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
