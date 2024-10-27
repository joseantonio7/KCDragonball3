import UIKit

class HeroDetailViewController: UIViewController {

    private let viewModel: HeroDetailViewModel
    
    @IBOutlet weak var image: AsyncImageView!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var heroName: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var container: UIStackView!
    @IBOutlet weak var errorContainer: UIStackView!
    @IBOutlet weak var boton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load()
    }

    
    
    @IBAction func didPressTransformations(_ sender: Any) {

    }
    // MARK: - States
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
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
        errorContainer.isHidden = false
        container.isHidden = true
        errorLabel.text = reason
    }
    
    private func renderLoading() {
        spinner.startAnimating()
        errorContainer.isHidden = true
        container.isHidden = true
    }
    
    private func renderSuccess() {
        spinner.stopAnimating()
        errorContainer.isHidden = true
        container.isHidden = false
        
        self.image.setImage(viewModel.hero.photo)
        self.heroName.text = viewModel.hero.name
        self.heroDescription.text = viewModel.hero.description
    }
    
    
}
