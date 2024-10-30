import Foundation

protocol APIInterceptor { }

protocol APIRequestInterceptor: APIInterceptor {
    func intercept(request: inout URLRequest)
}


final class AuthenticationRequestInterceptor: APIRequestInterceptor {
    private let dataSource: SecureDataStoreProtocol
    
    init(dataSource: SecureDataStoreProtocol = SecureDataStore()) {
        self.dataSource = dataSource
    }
    
    func intercept(request: inout URLRequest) {
        guard let session = dataSource.getToken() else {
            return
        }
        request.setValue("Bearer \(session)", forHTTPHeaderField: "Authorization")
    }
}
