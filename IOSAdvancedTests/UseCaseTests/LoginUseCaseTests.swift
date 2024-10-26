@testable import IOSAdvanced
import XCTest

final class APISessionMock: APISessionContract {
    let mockResponse: ((any APIRequest) -> Result<Data, any Error>)
    
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, any Error>) {
        self.mockResponse = mockResponse
    }
    
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(mockResponse(apiRequest))
    }
}

final class DummySessionDataSource: SessionDataSourceContract {
    private(set) var session: Data?
        
    func storeSession(_ session: Data) {
        self.session = session
    }
    
    func getSession() -> Data? { nil }

}

final class LoginUseCaseTests: XCTestCase {
    func testSuccessStoresToken() {
        let dataSource = DummySessionDataSource()
        let sut = LoginUseCase(dataSource: dataSource)
        
        let expectation = self.expectation(description: "TestSuccess")
        let data = Data("hello-world".utf8)
        
        APISession.shared = APISessionMock { _ in .success(data) }
        sut.execute(credentials: Credentials(username: "a@b.es", password: "122345")) { result in
            guard case .success = result else {
                return
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        XCTAssertEqual(dataSource.session, data)
    }
}
