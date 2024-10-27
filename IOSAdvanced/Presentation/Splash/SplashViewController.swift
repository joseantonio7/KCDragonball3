import UIKit

final class SplashViewController: UIViewController {
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    private let viewModel: SplashViewModel
    private var nextScreen :UIViewController
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        self.nextScreen = UIViewController()
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load(build:{[ weak self] in
            
            //DESCOMENTAR PARA BORRAR TOKEN
            //SecureDataStore.shared.deleteToken()
            
            
            if SecureDataStore.shared.getToken() != nil {
                self?.nextScreen = HeroesListBuilder().build()
            } else {
                self?.nextScreen = LoginBuilder().build()
            }
        })
    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.setAnimation(true)
            case .ready:
                self?.ready()
            case .error:
                break
            }
        }
    }
    
    private func ready(){
        setAnimation(false)
        present(nextScreen, animated: true)
    }
    
    private func setAnimation(_ animating: Bool) {
        switch spinner.isAnimating {
        case true where !animating:
            spinner.stopAnimating()
        case false where animating:
            spinner.startAnimating()
        default:
            break
        }
    }
}

#Preview {
    SplashBuilder().build()
}
