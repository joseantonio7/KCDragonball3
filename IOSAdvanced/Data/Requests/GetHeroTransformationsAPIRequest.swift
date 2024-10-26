import Foundation

struct GetHeroTransformationsAPIRequest: APIRequest {
    typealias Response = [ApiTransformation]
    
    let path: String = "/api/heros/tranformations"
    let method: HTTPMethod = .POST
    let body: (any Encodable)?
    
    init(identifier: String) {
        body = RequestEntity(identifier: identifier)
    }
}

private extension GetHeroTransformationsAPIRequest {
    struct RequestEntity: Encodable {
        let identifier: String
        
        enum CodingKeys: String, CodingKey {
            case identifier = "id"
        }
    }
}


