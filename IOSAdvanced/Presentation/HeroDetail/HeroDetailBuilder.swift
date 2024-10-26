import UIKit

final class HeroDetailBuilder {
    func build(name: String) -> UIViewController {
        let useCase = GetHeroUseCase()
        let viewModel = HeroDetailViewModel(name: name, useCase: useCase)
        let viewController = HeroDetailViewController(viewModel: viewModel)
        
        return viewController
    }
}
