import Foundation

enum HeroDetailState: Equatable {
    case loading
    case error(reason: String)
    case success
    case locationUpdated
}

final class HeroDetailViewModel {
    let onStateChanged = Binding<HeroDetailState>()
    private(set) var hero: Hero
    private let useCase: HeroDetailUseCase?
    var annotations: [HeroAnnotation] = []
    var transformations: [Transformation] = []

    
    init(hero: Hero, useCase: HeroDetailUseCase) {
        self.useCase = useCase
        self.hero = hero
    }
    
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase?.loadLocationsForHeroWith(id: hero.identifier, completion: { [weak self] result in
            switch result {
            case .success(let locations):
                locations.forEach { [weak self]  location in
                    guard let coordinate = location.coordinate else {
                        return
                    }
                    let annotation = HeroAnnotation(title: self?.hero.name, coordinate: coordinate)
                    self?.annotations.append(annotation)
                }
                self?.onStateChanged.update(newValue: .locationUpdated)
            case .failure(let error):
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        })
        
        useCase?.loadTransformationsForHeroWith(id: hero.identifier, completion: { [weak self] result in
            switch result {
            case .success(let transformations):
                self?.transformations = transformations
                self?.onStateChanged.update(newValue: .success)
            case .failure(let error):
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        })
    }
}

