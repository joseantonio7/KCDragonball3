//
//  TransformationsListViewController.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 27-10-24.
//


import UIKit

final class TransformationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorContainer: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let viewModel: TransformationsListViewModel
    private var id = ""
    
    init(viewModel: TransformationsListViewModel, id: String) {
        self.viewModel = viewModel
        self.id = id
        super.init(nibName: "TransformationsListView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TransformationTableViewCell.nib, forCellReuseIdentifier: TransformationTableViewCell.reuseIdentifier)
        bind()
        viewModel.load(id: id)
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
        tableView.isHidden = true
        errorLabel.text = reason
    }
    
    private func renderLoading() {
        spinner.startAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = true
    }
    
    private func renderSuccess() {
        spinner.stopAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transformations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransformationTableViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? TransformationTableViewCell {
            let transformation = viewModel.transformations[indexPath.row]
            cell.setAvatar(transformation.photo)
            cell.setTransformationName(transformation.name)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transformation = viewModel.transformations[indexPath.row]
    
        let detailViewController = TransformationDetailBuilder().build(transformation: transformation)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}

