import UIKit
import Kingfisher

final class HeroTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HeroTableViewCell"
    static var nib: UINib { UINib(nibName: "HeroTableViewCell", bundle: Bundle(for: HeroTableViewCell.self)) }
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet private weak var heroName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setAvatar(_ photo: String) {
        let options = KingfisherOptionsInfo([.transition(.fade(0.3)), .forceTransition])
        avatar.kf.setImage(with: URL(string: photo), options: options)
    }
    
    func setHeroName(_ heroName: String) {
        self.heroName.text = heroName
    }
}
