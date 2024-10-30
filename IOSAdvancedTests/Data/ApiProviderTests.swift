//
//  ApiProviderTests.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//

import XCTest
@testable import IOSAdvanced

final class ApiProviderTests: XCTestCase {
    
    var sut: GetHeroesAPIRequest!
    var apisession: APISessionContract!

    override func setUpWithError() throws {
        apisession = APISessionMock()
        sut = GetHeroesAPIRequest(name: "")
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        SecureDataStorageMock().deleteToken()
        sut = nil
        try super.tearDownWithError()
        URLProtocolMock.handler = nil
    }
    
    func test_loadHeros_shouldReturn_26_Heroes() throws {
        // Given

        let expectedToken = "Some Token"
        let expectedHero = try MockData.mockHeroes().first!
        var heroesResponse = [ApiHero]()

        URLProtocolMock.handler = { request in
            
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/all"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expectedToken)")
            
            let data = try MockData.loadHeroesData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        
        // When
        let expectation = expectation(description: "Load Heroes")
        setToken(expectedToken)
        sut.perform(session: apisession) { result in
            switch result {
            case .success(let apiheroes):
                heroesResponse = apiheroes
                expectation.fulfill()
            case .failure( _):
                XCTFail("Success expected")
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(heroesResponse.count, 26)
        let heroReceived = heroesResponse.first
        XCTAssertEqual(heroReceived?.identifier, expectedHero.identifier)
        XCTAssertEqual(heroReceived?.name, expectedHero.name)
        XCTAssertEqual(heroReceived?.description, expectedHero.description)
        XCTAssertEqual(heroReceived?.favorite, expectedHero.favorite)
        XCTAssertEqual(heroReceived?.photo, expectedHero.photo)
        
    }
    
    func test_loadHerosError_shouldReturn_Error() throws {
        // Given
        let expectedToken = "Some Token"
        var error: APIErrorResponse!
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        
        // When
        let expectation = expectation(description: "Load Heroes Error")
        setToken(expectedToken)
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
    
    func test_loadHerosError_shouldReturn_Error_503() throws {
        // Given
        let expectedToken = "Some Token"
        var error: APIErrorResponse!

        URLProtocolMock.handler = { request in
            let data = try MockData.loadNoData()
            let response = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: 503, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        let expectation = expectation(description: "Load Heroes Error 503")
        setToken(expectedToken)
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
    
    func setToken(_ token: String) {
        SecureDataStorageMock().set(token: token)
    }

}
