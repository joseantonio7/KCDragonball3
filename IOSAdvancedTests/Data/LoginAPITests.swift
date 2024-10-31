import XCTest
@testable import IOSAdvanced

final class LoginAPITests: XCTestCase {
    
    var sut: LoginAPIRequest!
    var apisession: APISessionContract!
    var secureDataStore: SecureDataStoreProtocol!

    override func setUpWithError() throws {
        apisession = APISessionMock()
        let credentials = Credentials(username: "test@goku.com",password: "1234qwerty")
        sut = LoginAPIRequest(credentials: credentials)
        URLProtocolMock.error = nil
        secureDataStore = SecureDataStoreMock()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        SecureDataStorageMock().deleteToken()
        sut = nil
        try super.tearDownWithError()
        URLProtocolMock.handler = nil
    }
    
    func test_login_shouldReturn_Token() throws {
        // Given
        URLProtocolMock.handler = { request in
            
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/auth/login"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            
            let data = try MockData.login()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        
        // When
        let expectation = expectation(description: "Login")
        sut.perform(session: apisession) { [weak self] result in
            switch result {
            case .success( let data ):
                self?.secureDataStore.set(token: String(decoding: data, as: UTF8.self))
                expectation.fulfill()
            case .failure( _):
                XCTFail("Success expected")
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(secureDataStore.getToken()!, "eyJraWQiOiJwcml2YXRlIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJpZGVudGlmeSI6IjdBQjhBQzRELUFEOEYtNEFDRS1BQTQ1LTIxRTg0QUU4QkJFNyIsImVtYWlsIjoiYmVqbEBrZWVwY29kaW5nLmVzIiwiZXhwaXJhdGlvbiI6NjQwOTIyMTEyMDB9.Dxxy91hTVz3RTF7w1YVTJ7O9g71odRcqgD00gspm30s")
        
    }
    
    func test_login_Error_shouldReturn_401() throws {
        // Given
        var error: APIErrorResponse!
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 401)
        
        // When
        let expectation = expectation(description: "Login Error")
        sut.perform(session: apisession){ result in
            switch result {
            case .success( _):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }

        //Then
        wait(for: [expectation], timeout: 2)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.message, "Unknown error")
    }
    
    func test_loginError_shouldReturn_Error_503() throws {
        // Given
        var error: APIErrorResponse!

        URLProtocolMock.handler = { request in
            let data = try MockData.loadNoData()
            let response = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: 503, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        let expectation = expectation(description: "Load Login Error 503")
        sut.perform(session: apisession){ result in
            switch result {
            case .success( _):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }

        //Then
        wait(for: [expectation], timeout: 2)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.message, "Network connection error \(503)")
    }

}
