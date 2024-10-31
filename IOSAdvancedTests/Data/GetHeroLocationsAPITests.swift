
import XCTest
@testable import IOSAdvanced

final class GetHeroLocationsAPITests: XCTestCase {
    
    var sut: GetHeroLocalizationsAPIRequest!
    var apisession: APISessionContract!

    override func setUpWithError() throws {
        apisession = APISessionMock()
        sut = GetHeroLocalizationsAPIRequest(identifier: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94")
        URLProtocolMock.error = nil
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        SecureDataStorageMock().deleteToken()
        sut = nil
        try super.tearDownWithError()
        URLProtocolMock.handler = nil
    }
    
    func test_loadLocations_shouldReturn_2_locations() throws {
        // Given

        let expectedLocation = try MockData.mockLocations().first!
        var locationsResponse = [ApiLocation]()

        URLProtocolMock.handler = { request in
            
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/locations"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            
            let data = try MockData.loadLocationData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        
        // When
        let expectation = expectation(description: "Load Locations")
        sut.perform(session: apisession) { result in
            switch result {
            case .success(let apiLocation):
                locationsResponse = apiLocation
                expectation.fulfill()
            case .failure( _):
                XCTFail("Success expected")
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(locationsResponse.count, 2)
        let locationReceived = locationsResponse.first
        XCTAssertEqual(locationReceived?.identifier, expectedLocation.identifier)
        XCTAssertEqual(locationReceived?.latitude, expectedLocation.latitude)
        XCTAssertEqual(locationReceived?.longitude, expectedLocation.longitude)
        
    }
    
    func test_loadLocationsError_shouldReturn_Error() throws {
        // Given
        var error: APIErrorResponse!
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        
        // When
        let expectation = expectation(description: "Load Locations Error")
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
    
    func test_loadLocationsError_shouldReturn_Error_401() throws {
        // Given
        var error: APIErrorResponse!

        URLProtocolMock.handler = { request in
            let data = try MockData.loadNoData()
            let response = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: 401, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        let expectation = expectation(description: "Load Locations Error 401")
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
