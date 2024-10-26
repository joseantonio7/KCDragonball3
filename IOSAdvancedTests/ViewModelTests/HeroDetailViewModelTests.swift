@testable import SWPatterns
import XCTest

private final class SuccessGetHeroUseCaseMock: GetHeroUseCaseContract {
    func execute(name: String, completion: @escaping (Result<SWPatterns.Hero, any Error>) -> Void) {
        completion(.success(Hero(identifier: "777",
                                  name: "goku",
                                  description: "Sayan",
                                  photo: "",
                                  favorite: false)))
    }
}

private final class FailedGetHeroUseCaseMock: GetHeroUseCaseContract {
    func execute(name: String, completion: @escaping (Result<SWPatterns.Hero, any Error>) -> Void) {
        completion(.failure(APIErrorResponse.unknown("")))
    }
}


final class HeroDetailViewModelTests: XCTestCase {
    
    func testSuccessScenario() {
        let successExpectation = expectation(description: "Success")
        let loadingExpectation = expectation(description: "Loading")
        let useCaseMock = SuccessGetHeroUseCaseMock()
        let sut = HeroDetailViewModel(name: "goku", useCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if state == .success {
                successExpectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.hero?.description,"Sayan")
    }
    
    func testFailScenario() {
        let errorExpectation = expectation(description: "Error")
        let loadingExpectation = expectation(description: "Loading")
        let useCaseMock = FailedGetHeroUseCaseMock()
        let sut = HeroDetailViewModel(name: "goku", useCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if case .error = state {
                errorExpectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.hero, nil)
    }
}
