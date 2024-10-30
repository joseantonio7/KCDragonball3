import UIKit

final class HeroesListBuilder {
    func build() -> UIViewController {
        let useCase = HeroUseCase(apisession: APISession.shared, apiProvider: GetHeroesAPIRequest(name: nil), storeDataProvider: StoreDataProvider.shared)
        let viewModel = HeroesListViewModel(useCase: useCase)
        let viewController = HeroesListViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        return navigationController
    }
}
