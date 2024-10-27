//
//  ApiProviderMock.swift
//  IOSAdvancedTests
//
//  Created by José Antonio Aravena on 27-10-24.
//

@testable import IOSAdvanced

class ApiProviderMock {
    func loadHeros(name: String, completion: @escaping ((Result<[ApiHero], APIErrorResponse>) -> Void)) {
        do {
            let heroes = try MockData.mockHeroes()
            completion(.success(heroes))
        } catch {
            completion(.failure(APIErrorResponse.empty("")))
        }
    }
    
    func loadLocations(id: String, completion: @escaping ((Result<[ApiLocation], APIErrorResponse>) -> Void)) {
        let locations = [ApiLocation(identifier: "id", date: "date", latitude: "latitud", longitude: "0000", hero: nil)]
        completion(.success(locations))
    }
    
    func loadTransformations(id: String, completion: @escaping ((Result<[ApiTransformation], APIErrorResponse>) -> Void)) {
        let trnasformations = [ApiTransformation(identifier: "id", name: "name", photo: "photo", description: "desc", hero: nil)]
        completion(.success(trnasformations))
    }
    
    
}

class ApiProviderErrorMock {
    func loadHeros(name: String, completion: @escaping ((Result<[ApiHero], APIErrorResponse>) -> Void)) {
        completion(.failure(APIErrorResponse.empty("")))
    }
    func loadLocations(id: String, completion: @escaping ((Result<[ApiLocation], APIErrorResponse>) -> Void)) {
        completion(.failure(APIErrorResponse.empty("")))
    }
    
    func loadTransformations(id: String, completion: @escaping ((Result<[ApiTransformation], APIErrorResponse>) -> Void)) {
        completion(.failure(APIErrorResponse.empty("")))
    }
}
