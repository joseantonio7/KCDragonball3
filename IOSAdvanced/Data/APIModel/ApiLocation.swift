//
//  ApiLocation.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 26-10-24.
//

struct ApiLocation: Codable {
    let identifier: String?
    let date: String?
    let latitude: String?
    let longitude: String?
    let hero: ApiHero?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case date = "dateShow"
        case latitude = "latitud"
        case longitude = "longitud"
        case hero
    }
}
