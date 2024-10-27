import Foundation

enum HeroDetailState: Equatable {
    case loading
    case error(reason: String)
    case success
}

final class HeroDetailViewModel {
    let onStateChanged = Binding<HeroDetailState>()
    private(set) var hero: Hero
    private let useCase: HeroDetailUseCase?

    
    init(hero: Hero, useCase: HeroDetailUseCase) {
        self.useCase = useCase
        self.hero = hero
    }
    
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase?.loadTransformationsForHeroWith(id: hero.identifier, completion: { [weak self] result in
            switch result {
            case .success(let transformations):
                self?.onStateChanged.update(newValue: .success)
            case .failure(let error):
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        })
    }
}

