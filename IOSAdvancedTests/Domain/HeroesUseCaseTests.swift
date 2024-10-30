//
//  HeroesUseCaseTests.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//

import XCTest

@testable import IOSAdvanced

final class HeroesUseCaseTests: XCTestCase {
    
    var sut: HeroUseCase!
    var storeDataProvider: StoreDataProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        storeDataProvider = StoreDataProvider(persistency: .inMemory)
        sut = HeroUseCase(apisession: APISessionMock(), apiProvider: GetHeroesAPIRequest(name: ""), storeDataProvider: storeDataProvider)

    }

    override func tearDownWithError() throws {
        storeDataProvider = nil
        sut = nil
        URLProtocolMock.handler = nil
        try super.tearDownWithError()
    }
    
    func test_LoadHeroes_ShouldReturnHeroes() {
        //Given
        let expectedHeroees = try? MockData.mockHeroes()
        var receivedHeroes: [Hero]?
        
        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/all"))
            let data = try MockData.loadHeroesData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
           return  (data, response)
        }
        
        //When
        let expectation = expectation(description: "Load heroes")
        sut.loadHeros { result in
            switch result {
            case .success(let heroes):
                receivedHeroes = heroes
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success")
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 7)
        XCTAssertNotNil(receivedHeroes)
        XCTAssertEqual(receivedHeroes?.count, expectedHeroees?.count)
        let bdHeroes = storeDataProvider.fetchHeroes(filter: nil)
        XCTAssertEqual(receivedHeroes?.count, bdHeroes.count)
    }
    
    func test_LoadHeroes_Error_ShouldREturnError() {
        //Given
        var error: APIErrorResponse?
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        
        //When
        let expectation = expectation(description: "Load heroes return error")
        sut.loadHeros { result in
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
        XCTAssertEqual(error?.message, "Unknown error")
    }
    
    func test_LoadHeroes_SuldReturn_DataFiltered() {
        // Given
        let expectedHeros = 3
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", "g")
        var receivedHeroes: [Hero]?
        
        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/all"))
            let data = try MockData.loadHeroesData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
           return  (data, response)
        }
        
        // When
        let expectation = expectation(description: "Load heroes filtered with 'g' in his name")
        sut.loadHeros(filter: predicate) { result in
            switch result {
            case .success(let heroes):
                receivedHeroes = heroes
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected succes")
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(receivedHeroes?.count, expectedHeros)
    }
}
