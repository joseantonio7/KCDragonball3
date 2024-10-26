import Foundation

protocol GetHeroUseCaseContract {
    func execute(name: String, completion: @escaping (Result<Hero, Error>) -> Void)
}

final class GetHeroUseCase: GetHeroUseCaseContract {
    func execute(name: String, completion: @escaping (Result<Hero, any Error>) -> Void) {
        GetHeroesAPIRequest(name: name)
            .perform { result in
                do {
                    let heroes = try result.get()
                    if let hero = heroes.first {
                        completion(.success(hero))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
