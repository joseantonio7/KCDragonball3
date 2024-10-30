
import XCTest

@testable import IOSAdvanced


final class LoginUseCaseTests: XCTestCase {
    
    var sut: LoginUseCase!
    var session: APISessionContract!
    var credentials: Credentials!
    var secureDataStore: SecureDataStoreProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        session = APISessionMock()
        secureDataStore = SecureDataStoreMock()
        sut = LoginUseCase(apisession: session, dataSource: secureDataStore)

    }

    override func tearDownWithError() throws {
        sut = nil
        URLProtocolMock.handler = nil
        try super.tearDownWithError()
    }
    
    func test_Login_ShouldReturnSuccess() {
        //Given
        credentials = Credentials(username: "juan@goku.mail.com", password: "1234567qwerty")
        
        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/auth/login"))
            let data = try MockData.login()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
           return  (data, response)
        }
        
        //When
        let expectation = expectation(description: "Login")
        sut.execute(credentials: credentials) { result in
            switch result {
            case .success():
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success")
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(secureDataStore.getToken()!, "eyJraWQiOiJwcml2YXRlIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJpZGVudGlmeSI6IjdBQjhBQzRELUFEOEYtNEFDRS1BQTQ1LTIxRTg0QUU4QkJFNyIsImVtYWlsIjoiYmVqbEBrZWVwY29kaW5nLmVzIiwiZXhwaXJhdGlvbiI6NjQwOTIyMTEyMDB9.Dxxy91hTVz3RTF7w1YVTJ7O9g71odRcqgD00gspm30s")
    }
    
    func test_Login_Error_ShouldREturnError() {
        //Given
        var error: LoginUseCaseError?
        credentials = Credentials(username: "juan@goku.mail.com", password: "1234567qwerty")
        URLProtocolMock.handler = { result in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/auth/login"))
            let data = try MockData.loadNoData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 500, httpVersion: nil, headerFields: nil)!
           return  (data, response)
        }
        
        //When
        let expectation = expectation(description: "Login return error")
        sut.execute(credentials: credentials) { result in
            switch result {
            case .success(_):
                XCTFail("Expected error")
            case .failure(let errorReceived):
                error = errorReceived
                expectation.fulfill()
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.reason, "Network failed")
    }

    
    func test_Invalid_Username_Error_ShouldREturnError() {
        //Given
        var error: LoginUseCaseError?
        credentials = Credentials(username: "juangoku.mail.com", password: "1234567qwerty")
        URLProtocolMock.handler = { result in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/auth/login"))
            let data = try MockData.loadNoData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 500, httpVersion: nil, headerFields: nil)!
           return  (data, response)
        }
        
        //When
        let expectation = expectation(description: "Login return error")
        sut.execute(credentials: credentials) { result in
            switch result {
            case .success(_):
                XCTFail("Expected error")
            case .failure(let errorReceived):
                error = errorReceived
                expectation.fulfill()
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.reason, "Invalid username")
    }
    
    func test_Invalid_Password_Error_ShouldREturnError() {
        //Given
        var error: LoginUseCaseError?
        credentials = Credentials(username: "juan@goku.mail.com", password: "123")
        URLProtocolMock.handler = { result in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/auth/login"))
            let data = try MockData.loadNoData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 500, httpVersion: nil, headerFields: nil)!
           return  (data, response)
        }
        
        //When
        let expectation = expectation(description: "Login return error")
        sut.execute(credentials: credentials) { result in
            switch result {
            case .success(_):
                XCTFail("Expected error")
            case .failure(let errorReceived):
                error = errorReceived
                expectation.fulfill()
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.reason, "Invalid password")
    }

}
