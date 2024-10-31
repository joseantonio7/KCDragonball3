
import XCTest
@testable import IOSAdvanced

final class GetHeroTransformationsAPITests: XCTestCase {
    
    var sut: GetHeroTransformationsAPIRequest!
    var apisession: APISessionContract!

    override func setUpWithError() throws {
        apisession = APISessionMock()
        sut = GetHeroTransformationsAPIRequest(identifier: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94")
        URLProtocolMock.error = nil
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        SecureDataStorageMock().deleteToken()
        sut = nil
        try super.tearDownWithError()
        URLProtocolMock.handler = nil
    }
    
    func test_loadTransformations_shouldReturn_15_transformations() throws {
        // Given

        let expectedTransformations = try MockData.mockTransformations().first!
        var transformationsResponse = [ApiTransformation]()

        URLProtocolMock.handler = { request in
            
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            
            let data = try MockData.loadTransformationData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        
        // When
        let expectation = expectation(description: "Load Transformations")
        sut.perform(session: apisession) { result in
            switch result {
            case .success(let apiTransformations):
                transformationsResponse = apiTransformations
                expectation.fulfill()
            case .failure( _):
                XCTFail("Success expected")
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(transformationsResponse.count, 15)
        let transformationReceived = transformationsResponse.first
        XCTAssertEqual(transformationReceived?.identifier, expectedTransformations.identifier)
        XCTAssertEqual(transformationReceived?.name, expectedTransformations.name)
        XCTAssertEqual(transformationReceived?.description, expectedTransformations.description)
        XCTAssertEqual(transformationReceived?.photo, expectedTransformations.photo)
        
    }
    
    func test_loadTransformationsError_shouldReturn_Error() throws {
        // Given
        var error: APIErrorResponse!
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        
        // When
        let expectation = expectation(description: "Load Transformations Error")
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
    
    func test_loadTransformationsError_shouldReturn_Error_401() throws {
        // Given
        var error: APIErrorResponse!

        URLProtocolMock.handler = { request in
            let data = try MockData.loadNoData()
            let response = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: 401, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        let expectation = expectation(description: "Load Transformations Error 401")
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
        XCTAssertEqual(receivedError.message, "Network connection error \(401)")
    }

}
