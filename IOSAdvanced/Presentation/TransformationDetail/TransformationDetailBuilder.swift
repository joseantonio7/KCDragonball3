//
//  TransformationDetailBuilder.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//


import UIKit

final class TransformationDetailBuilder {
    func build(transformation: Transformation) -> UIViewController {
        let viewController = TransformationDetailViewController(transformation: transformation)
        
        return viewController
    }
}

