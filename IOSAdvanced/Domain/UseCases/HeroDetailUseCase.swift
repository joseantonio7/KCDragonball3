import Foundation

protocol HeroDetailUseCaseProtocol {
    func loadLocationsForHeroWith(id: String, completion: @escaping ((Result<[Location], APIErrorResponse>) -> Void))
}

class HeroDetailUseCase: HeroDetailUseCaseProtocol {
    private var apiLocationProvider: GetHeroLocalizationsAPIRequest?
    private var apiTransformationProvider: GetHeroTransformationsAPIRequest?
    private var storeDataProvider: StoreDataProvider
    
    init(storeDataProvider: StoreDataProvider = .shared) {
        self.storeDataProvider = storeDataProvider
    }
    
    func loadLocationsForHeroWith(id: String, completion: @escaping ((Result<[Location], APIErrorResponse>) -> Void)) {
        guard let hero = self.getHeroWith(id: id) else {
            completion(.failure(.noHero(id)))
            return
        }
        let bdLocations = hero.locations ?? []
        if bdLocations.isEmpty {
            GetHeroLocalizationsAPIRequest(identifier: id).perform { result in
                switch result {
                case .success(let apiLocations):
                    DispatchQueue.main.async {
                        self.storeDataProvider.add(locations: apiLocations)
                        let bdLocations = hero.locations ?? []
                        let domainLocations = bdLocations.map({Location(moLocation: $0)})
                        completion(.success(domainLocations))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        } else {
            let domainLocations = bdLocations.map({Location(moLocation: $0)})
            completion(.success(domainLocations))
        }
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
