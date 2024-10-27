struct Transformation: Equatable {
    let identifier: String
    let name: String
    let description: String
    let photo: String
    
    init(moTransformation: MOTransformation) {
        self.identifier = moTransformation.identifier ?? ""
        self.name = moTransformation.name ?? ""
        self.description = moTransformation.info ?? ""
        self.photo = moTransformation.photo ?? ""
    }
}
