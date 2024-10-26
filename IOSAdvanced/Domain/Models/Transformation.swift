struct Transformation: Equatable, Decodable {
    let identifier: String
    let name: String
    let description: String
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case photo
    }
}
