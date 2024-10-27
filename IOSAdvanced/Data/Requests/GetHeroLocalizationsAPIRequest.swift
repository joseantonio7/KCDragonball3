//
//  GetHeroTransformationsAPIRequest 2.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 26-10-24.
//


import Foundation

struct GetHeroLocalizationsAPIRequest: APIRequest {
    typealias Response = [ApiLocation]
    
    let path: String = "/api/heros/locations"
    let method: HTTPMethod = .POST
    let body: (any Encodable)?
    
    init(identifier: String) {
        body = RequestEntity(identifier: identifier)
    }
}

private extension GetHeroLocalizationsAPIRequest {
    struct RequestEntity: Encodable {
        let identifier: String
        
        enum CodingKeys: String, CodingKey {
            case identifier = "id"
        }
    }
}


