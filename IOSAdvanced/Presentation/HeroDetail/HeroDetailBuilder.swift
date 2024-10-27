import UIKit

final class HeroDetailBuilder {
    func build(hero:Hero) -> UIViewController {
        let useCase = HeroDetailUseCase()
        let viewModel = HeroDetailViewModel(hero: hero, useCase: useCase)
        let viewController = HeroDetailViewController(viewModel: viewModel)
        
        return viewController
    }
}
