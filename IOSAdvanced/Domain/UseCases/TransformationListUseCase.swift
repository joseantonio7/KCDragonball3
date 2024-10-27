//
//  HeroDetailUseCaseProtocol.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//


import Foundation

protocol TransformationUseCaseProtocol {
    func loadTransformationsForHeroWith(id: String, completion: @escaping ((Result<[Transformation], APIErrorResponse>) -> Void))
}

class TransformationListUseCase: TransformationUseCaseProtocol {
    private var apiTransformationProvider: GetHeroTransformationsAPIRequest?
    private var storeDataProvider: StoreDataProvider
    
    init(storeDataProvider: StoreDataProvider = .shared) {
        self.storeDataProvider = storeDataProvider
    }

    func loadTransformationsForHeroWith(id: String, completion: @escaping ((Result<[Transformation], APIErrorResponse>) -> Void)) {
        guard let hero = self.getHeroWith(id: id) else {
            completion(.failure(.noHero(id)))
            return
        }
        let bdTransformations = hero.transformations ?? []
        if bdTransformations.isEmpty {
            GetHeroTransformationsAPIRequest(identifier: id).perform { result in
                switch result {
                case .success(let apiTransformations):
                    DispatchQueue.main.async {
                        self.storeDataProvider.add(transformations: apiTransformations)
                        let bdTransformations = hero.transformations ?? []
                        let domainTransformations = bdTransformations.map({Transformation(moTransformation: $0)})
                        completion(.success(domainTransformations))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        } else {
            let domainTransformations = bdTransformations.map({Transformation(moTransformation: $0)})
            completion(.success(domainTransformations))
        }
    }
    private func getHeroWith(id: String) -> MOHero? {
        let predicate = NSPredicate(format: "identifier == %@", id)
        let heroes = storeDataProvider.fetchHeroes(filter: predicate)
        return heroes.first
    }
}
