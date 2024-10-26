import Foundation

enum HeroDetailState: Equatable {
    case loading
    case error(reason: String)
    case success
}

final class HeroDetailViewModel {
    let onStateChanged = Binding<HeroDetailState>()
    private(set) var hero: Hero?
    private let useCase: GetHeroUseCaseContract
    private let name: String
    
    init(name: String, useCase: GetHeroUseCaseContract) {
        self.useCase = useCase
        self.name = name
    }
    
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase.execute(name: name) { [weak self] result in
            do {
                self?.hero = try result.get()
                self?.onStateChanged.update(newValue: .success)
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}

