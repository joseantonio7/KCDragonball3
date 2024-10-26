import UIKit

final class TransformationsListBuilder {
    func build(identifier: String) -> UIViewController {
        let useCase = GetTransformationsUseCase()
        let viewModel = TransformationsListViewModel(identifier: identifier, useCase: useCase)
        let viewController = TransformationsListViewController(viewModel: viewModel)
        
        return viewController
    }
}
