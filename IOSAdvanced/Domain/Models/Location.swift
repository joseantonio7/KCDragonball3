//
//  Location.swift
//  SWPatterns
//
//  Created by José Antonio Aravena on 26-10-24.
//


struct Location: Equatable, Decodable {
    let identifier: String
    let date: String
    let latitude: String
    let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case date
        case latitude
        case longitude
    }
}
