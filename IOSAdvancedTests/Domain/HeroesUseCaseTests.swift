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
        sut = HeroUseCase(apiProvider: ApiProviderMock(), storeDataPRovider: storeDataProvider)
    }

    override func tearDownWithError() throws {
        storeDataProvider = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_LoadHeroes_ShouldReturnHeroes() {
        //Given
        let expectedHeroees = try? MockData.mockHeroes()
        var receivedHeroes: [Hero]?
        
        //When
        let expectation = expectation(description: "Load heroes")
        sut.loadHeros { result in
            switch result {
            case .success(let heroes):
                receivedHeroes = heroes
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected succes")
            }
        }
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(receivedHeroes)
        XCTAssertEqual(receivedHeroes?.count, expectedHeroees?.count)
        let bdHeroes = storeDataProvider.fetchHeroes(filter: nil)
        XCTAssertEqual(receivedHeroes?.count, bdHeroes.count)
    }
    
    func test_LoadHeroes_Error_ShouldREturnError() {
        //Given
        sut = HeroUseCase(apiProvider: ApiProviderErrorMock(), storeDataPRovider: storeDataProvider)
        var error: GAError?
        
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
        XCTAssertEqual(error?.description, "Data no received from server")
    }
    
    func test_LoadHeroes_SuldReturn_DataFiltered() {
        // Gicen
        let expectedHeros = 3
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", "g")
        var receivedHeroes: [Hero]?
        
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
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(receivedHeroes?.count, expectedHeros)
    }
}
