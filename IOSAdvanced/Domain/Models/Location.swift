//
//  Location.swift
//  SWPatterns
//
//  Created by José Antonio Aravena on 26-10-24.
//
import MapKit

struct Location: Equatable {
    let identifier: String
    let date: String
    let latitude: String
    let longitude: String

    init(moLocation: MOLocation) {
        self.identifier = moLocation.identifier ?? ""
        self.date = moLocation.date ?? ""
        self.latitude = moLocation.latitude ?? ""
        self.longitude = moLocation.longitude ?? ""
    }
}

extension Location {
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = Double(self.latitude),
              let longitude = Double(self.longitude),
              abs(latitude) <= 90,
              abs(longitude) <= 180 else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
              
    }
}
