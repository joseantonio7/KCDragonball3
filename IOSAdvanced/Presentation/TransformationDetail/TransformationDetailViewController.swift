//
//  TransformationDetailViewController.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//

import UIKit
import Kingfisher

class TransformationDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var container: UIStackView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var transformation: Transformation?
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    init(transformation: Transformation) {
        super.init(nibName: "TransformationDetailView", bundle: Bundle(for: type(of: self)))
        self.transformation = transformation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        spinner.stopAnimating()
        container.isHidden = false
        let options = KingfisherOptionsInfo([.transition(.fade(0.3)), .forceTransition])
        imageView.kf.setImage(with: URL(string: transformation?.photo ?? ""), options: options)
        
        self.titleLabel.text = transformation?.name
        self.descriptionLabel.text = transformation?.description
    }
    
    
}
