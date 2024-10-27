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
    var id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel?.load(id: id)
    }
    private var viewModel: TransformationDetailViewModel?
    init(viewModel: TransformationDetailViewModel, id: String) {
        super.init(nibName: "TransformationDetailView", bundle: Bundle(for: type(of: self)))
        self.viewModel = viewModel
        self.id = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - States
    private func bind() {
        viewModel?.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case .error(let error):
                self?.renderError(error)
            }
        }
    }
    
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        container.isHidden = true
        let alert = UIAlertController(title: "G & F", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func renderLoading() {
        spinner.startAnimating()
        container.isHidden = true
    }
    
    private func renderSuccess() {
        spinner.stopAnimating()
        container.isHidden = false
        let options = KingfisherOptionsInfo([.transition(.fade(0.3)), .forceTransition])
        imageView.kf.setImage(with: URL(string: viewModel?.transformation?.photo ?? ""), options: options)
        
        self.titleLabel.text = viewModel?.transformation?.name
        self.descriptionLabel.text = viewModel?.transformation?.description
    }
    
    
}
