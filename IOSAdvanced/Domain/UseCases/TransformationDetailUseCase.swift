//
//  HeroDetailUseCaseProtocol.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//


import Foundation

protocol TransformationDetailUseCaseProtocol {
    func getTransformationWith(id: String) -> MOTransformation?
}

class TransformationDetailUseCase: TransformationDetailUseCaseProtocol {
    func getTransformationWith(id: String) -> MOTransformation? {
        let predicate = NSPredicate(format: "identifier == %@", id)
        let transformations = storeDataProvider.fetchTransformations(filter: predicate)
        return transformations.first
    }
    
    private var apiTransformationProvider: GetHeroTransformationsAPIRequest?
    private var storeDataProvider: StoreDataProvider
    
    init(storeDataProvider: StoreDataProvider = .shared) {
        self.storeDataProvider = storeDataProvider
    }
    

}
