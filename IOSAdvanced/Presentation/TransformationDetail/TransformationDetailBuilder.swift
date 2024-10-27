//
//  TransformationDetailBuilder.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//


import UIKit

final class TransformationDetailBuilder {
    func build(id: String) -> UIViewController {
        let useCase = TransformationDetailUseCase()
        let viewModel = TransformationDetailViewModel(useCase: useCase)
        let viewController = TransformationDetailViewController(viewModel: viewModel, id: id)
        
        return viewController
    }
}

