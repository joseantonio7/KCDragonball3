//
//  HeroesListState.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//


import Foundation

enum TransformationsListState: Equatable {
    case loading
    case error(reason: String)
    case success
}

final class TransformationsListViewModel {
    let onStateChanged = Binding<TransformationsListState>()
    private(set) var transformations: [Transformation] = []
    private let useCase: TransformationUseCaseProtocol
    private var hero: Hero?
    
    init(useCase: TransformationUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func load() {
        onStateChanged.update(newValue: .loading)
        
        useCase.loadTransformationsForHeroWith(id: hero?.identifier ?? "") { [weak self] result in
            switch result {
            case .success(let transformations):
                self?.transformations = transformations
                self?.onStateChanged.update(newValue: .success)
            case .failure(let error):
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
