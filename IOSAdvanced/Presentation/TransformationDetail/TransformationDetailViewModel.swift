//
//  HeroDetailState.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//


import Foundation

enum TransformationDetailState: Equatable {
    case loading
    case error(reason: String)
    case success
}

final class TransformationDetailViewModel {
    let onStateChanged = Binding<TransformationDetailState>()
    private(set) var transformation: Transformation?
    private let useCase: TransformationDetailUseCase

    
    init(useCase: TransformationDetailUseCase) {
        self.useCase = useCase
    }
    
    func load(id: String) {
        onStateChanged.update(newValue: .loading)
        guard let transformation = useCase.getTransformationWith(id: id).map({Transformation(moTransformation: $0)}) else{
            onStateChanged.update(newValue: .error(reason: "error"))
            return
        }
        self.transformation = transformation
        onStateChanged.update(newValue: .success)
    }
}

