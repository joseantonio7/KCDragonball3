import Foundation

protocol APIInterceptor { }

protocol APIRequestInterceptor: APIInterceptor {
    func intercept(request: inout URLRequest)
}


final class AuthenticationRequestInterceptor: APIRequestInterceptor {
    private let dataSource: SecureDataStore
    
    init(dataSource: SecureDataStore = SecureDataStore()) {
        self.dataSource = dataSource
    }
    
    func intercept(request: inout URLRequest) {
        guard let session = dataSource.getToken() else {
            return
        }
        print(session)
        request.setValue("Bearer \(session)", forHTTPHeaderField: "Authorization")
    }
}
