//
//  Location.swift
//  SWPatterns
//
//  Created by José Antonio Aravena on 26-10-24.
//


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
