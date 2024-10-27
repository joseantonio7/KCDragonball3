struct Hero: Equatable {
    let identifier: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
    
    init(moHero: MOHero) {
        self.identifier = moHero.identifier ?? ""
        self.name = moHero.name ?? ""
        self.description = moHero.info ?? ""
        self.photo = moHero.photo ?? ""
        self.favorite = moHero.favorite
    }
}
