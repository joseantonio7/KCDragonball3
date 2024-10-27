import Foundation

protocol LoginUseCaseContract {
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void)
}

final class LoginUseCase: LoginUseCaseContract {
    private let dataSource: SecureDataStore
    
    init(dataSource: SecureDataStore = SecureDataStore()) {
        self.dataSource = dataSource
    }
    
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void) {
        guard validateUsername(credentials.username) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid username")))
        }
        guard validatePassword(credentials.password) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid password")))
        }
        LoginAPIRequest(credentials: credentials)
            .perform { [weak self] result in
                switch result {
                case .success(let data):
                    self?.dataSource.set(token: String(data: data, encoding: .utf8) ?? "")
                    completion(.success(()))
                case .failure:
                    completion(.failure(LoginUseCaseError(reason: "Network failed")))
                }
            }
    }
    
    private func validateUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty
    }
    
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 4
    }
}

struct LoginUseCaseError: Error {
    let reason: String
}
