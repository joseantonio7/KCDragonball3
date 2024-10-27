import Foundation

enum HeroesListState: Equatable {
    case loading
    case error(reason: String)
    case success
}

final class HeroesListViewModel {
    let onStateChanged = Binding<HeroesListState>()
    private(set) var heroes: [Hero] = []
    private let useCase: HeroUseCaseProtocol
    
    init(useCase: HeroUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func load() {
        onStateChanged.update(newValue: .loading)
        
        
        useCase.loadHeros(filter: nil) { [weak self] result in
            switch result {
            case .success(let heroes):
                self?.heroes = heroes
                self?.onStateChanged.update(newValue: .success)
            case .failure(let error):
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
