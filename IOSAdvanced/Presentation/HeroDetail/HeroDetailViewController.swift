import UIKit
import MapKit

class HeroDetailViewController: UIViewController {

    private let viewModel: HeroDetailViewModel
    
    @IBOutlet weak var heroName: UILabel!
    
    @IBOutlet weak var heroDescription: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var container: UIStackView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private var locationManager: CLLocationManager = CLLocationManager()
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        bind()
        viewModel.load()
        checkLocationAuthorizationStatus()
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
            case .locationUpdated:
                self?.updateMapAnnotations()
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
        self.heroName.text = viewModel.hero.name
        self.heroDescription.text = viewModel.hero.description
        if (viewModel.transformations.count > 0){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Transformaciones", style: .plain, target: self, action: #selector(transformationList))
        }
    }
    
    private func updateMapAnnotations() {
        let oldAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(oldAnnotations)
        self.mapView.addAnnotations(viewModel.annotations)
        
        if let annotaion = viewModel.annotations.first {
            mapView.region = MKCoordinateRegion(center: annotaion.coordinate,
                                                latitudinalMeters: 100000,
                                                longitudinalMeters: 100000)
        }
        spinner.stopAnimating()
        container.isHidden = false
        self.heroName.text = viewModel.hero.name
        self.heroDescription.text = viewModel.hero.description
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
    }
    
    private func checkLocationAuthorizationStatus() {
        let authorizationStatus = locationManager.authorizationStatus
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            mapView.showsUserLocation = false
            mapView.showsUserTrackingButton = false
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    @objc func transformationList() {
        let detailViewController = TransformationsListBuilder().build(id: viewModel.hero.identifier)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension HeroDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? HeroAnnotation else {
            return nil
        }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: HeroAnnotationView.identifier)  {
            return annotationView
        }
        let annotationView = HeroAnnotationView(annotation: annotation,
                                                reuseIdentifier: HeroAnnotationView.identifier)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        debugPrint("Call accesory Tapped")
    }
}

