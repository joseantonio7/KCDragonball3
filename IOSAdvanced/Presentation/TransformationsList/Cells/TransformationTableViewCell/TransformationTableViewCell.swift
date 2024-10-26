import UIKit

class TransformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photo: AsyncImageView!
    @IBOutlet weak var name: UILabel!
    
    
    static let reuseIdentifier = "TransformationTableViewCell"
    static var nib: UINib { UINib(nibName: "TransformationTableViewCell", bundle: Bundle(for: HeroTableViewCell.self)) }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.cancel()
    }
    
    func setPhoto(_ url: String) {
        self.photo.setImage(url)
    }
    
    func setTransformationName(_ heroName: String) {
        self.name.text = heroName
    }
    
}
