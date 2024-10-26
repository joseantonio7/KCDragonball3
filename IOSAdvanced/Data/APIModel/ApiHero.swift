//
//  APIHero.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 26-10-24.
//

struct ApiHero:Codable {
    let identifier: String?
    let name: String?
    let description: String?
    let photo: String?
    var favorite: Bool?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case photo
        case favorite
    }
}
