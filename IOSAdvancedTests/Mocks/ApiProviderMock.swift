//
//  ApiProviderMock.swift
//  IOSAdvancedTests
//
//  Created by José Antonio Aravena on 27-10-24.
//

@testable import IOSAdvanced

class ApiProviderMock: ApiProviderProtocol {
    func loadHeros(name: String, completion: @escaping ((Result<[ApiHero], GAError>) -> Void)) {
        do {
            let heroes = try MockData.mockHeroes()
            completion(.success(heroes))
        } catch {
            completion(.failure(GAError.noDataReceived))
        }
    }
    
    func loadLocations(id: String, completion: @escaping ((Result<[ApiLocation], GAError>) -> Void)) {
        let locations = [ApiLocation(id: "id", date: "date", latitude: "latitud", longitude: "0000", hero: nil)]
        completion(.success(locations))
    }
    
    func loadTransformations(id: String, completion: @escaping ((Result<[ApiTransformation], GAError>) -> Void)) {
        let trnasformations = [ApiTransformation(id: "id", name: "name", photo: "photo", description: "desc", hero: nil)]
        completion(.success(trnasformations))
    }
    
    
}

class ApiProviderErrorMock: ApiProviderProtocol {
    func loadHeros(name: String, completion: @escaping ((Result<[ApiHero], GAError>) -> Void)) {
        completion(.failure(GAError.noDataReceived))
    }
    func loadLocations(id: String, completion: @escaping ((Result<[ApiLocation], GAError>) -> Void)) {
        completion(.failure(GAError.noDataReceived))
    }
    
    func loadTransformations(id: String, completion: @escaping ((Result<[ApiTransformation], GAError>) -> Void)) {
        completion(.failure(GAError.noDataReceived))
    }
}
