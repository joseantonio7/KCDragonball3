import Foundation

protocol LoginUseCaseContract {
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void)
    func validateUsername(_ username: String) -> Bool
    func validatePassword(_ password: String) -> Bool
}

final class LoginUseCase: LoginUseCaseContract {
    private let dataSource: SecureDataStoreProtocol
    private let apisession:APISessionContract
    
    init(apisession: APISessionContract = APISession.shared, dataSource: SecureDataStoreProtocol = SecureDataStore()) {
        self.dataSource = dataSource
        self.apisession = apisession
    }
    
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void) {
        guard validateUsername(credentials.username) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid username")))
        }
        guard validatePassword(credentials.password) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid password")))
        }
        LoginAPIRequest(credentials: credentials)
            .perform (session: apisession, completion: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.dataSource.set(token: String(data: data, encoding: .utf8) ?? "")
                    completion(.success(()))
                case .failure:
                    completion(.failure(LoginUseCaseError(reason: "Network failed")))
                }
            })
    }
    
    func validateUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty
    }
    
    func validatePassword(_ password: String) -> Bool {
        password.count >= 4
    }
}

struct LoginUseCaseError: Error {
    let reason: String
}
