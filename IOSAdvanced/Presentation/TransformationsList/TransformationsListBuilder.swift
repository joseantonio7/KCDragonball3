//
//  HeroesListBuilder.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//


import UIKit

final class TransformationsListBuilder {
    func build(id: String) -> UIViewController {
        let useCase = TransformationListUseCase(storeDataProvider: StoreDataProvider.shared)
        let viewModel = TransformationsListViewModel(useCase: useCase)
        let viewController = TransformationsListViewController(viewModel: viewModel, id: id)
        
        return viewController
    }
}
