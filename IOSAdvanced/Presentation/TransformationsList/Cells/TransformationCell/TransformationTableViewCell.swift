//
//  TransformationTableViewCell.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//

import UIKit
import Kingfisher

class TransformationTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TransformationTableViewCell"
    static var nib: UINib { UINib(nibName: "TransformationTableViewCell", bundle: Bundle(for: TransformationTableViewCell.self)) }
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var transformationName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setAvatar(_ photo: String) {
        let options = KingfisherOptionsInfo([.transition(.fade(0.3)), .forceTransition])
        avatar.kf.setImage(with: URL(string: photo), options: options)
    }
    
    func setTransformationName(_ transformationName: String) {
        self.transformationName.text = transformationName
    }
    
}
