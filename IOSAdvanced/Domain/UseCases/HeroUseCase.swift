import Foundation

protocol HeroUseCaseProtocol {
    func loadHeros(filter: NSPredicate?, completion: @escaping ((Result<[Hero], APIErrorResponse>) -> Void  ))
}

class HeroUseCase: HeroUseCaseProtocol {
    
    private var apiProvider: GetHeroesAPIRequest
    private var storeDataProvider: StoreDataProvider
    
    init(apiProvider: GetHeroesAPIRequest = GetHeroesAPIRequest(name: ""), storeDataProvider: StoreDataProvider = .shared) {
        self.apiProvider = apiProvider
        self.storeDataProvider = storeDataProvider
    }

    func loadHeros(filter: NSPredicate? = nil, completion: @escaping ((Result<[Hero], APIErrorResponse>) -> Void  )) {
        let localHeroes = storeDataProvider.fetchHeroes(filter: filter)
        if localHeroes.isEmpty {
            apiProvider.perform(session: APISession(), completion: { [weak self] result in
                switch result {
                case .success(let apiHeros):
                    DispatchQueue.main.async {
                        self?.storeDataProvider.add(heroes: apiHeros)
                        let bdHeroes = self?.storeDataProvider.fetchHeroes(filter: filter) ?? []
                        let heroes = bdHeroes.map({Hero(moHero: $0)})
                        completion(.success(heroes))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        } else {
            let heroes = localHeroes.map({Hero(moHero: $0)})
            completion(.success(heroes))
        }
    }
}
