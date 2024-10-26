//
//  APITransformation.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 26-10-24.
//

struct ApiTransformation: Codable {
    let identifier: String?
    let name: String?
    let photo: String?
    let description: String?
    let hero: ApiHero?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case photo
        case hero
    }
}
