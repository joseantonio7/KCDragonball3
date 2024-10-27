//
//  MKAnnotation.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 26-10-24.
//


import MapKit

class HeroAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
