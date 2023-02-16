//
//  ProfileConfigAboutVC.swift
//  Pods
//
//  Created by Ahmad Syauqi Albana on 10/01/23.
//  
//

import UIKit
import PrivyPassCore

class ProfileConfigAboutVC: UIViewController {
    
    // MARK: - Properties
    var presenter: ProfileConfigAboutViewToPresenterProtocol?
    internal lazy var tableView: UITableView = UITableView()
    
    // MARK: - Lifecycle Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAllData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar(title: L10n.wrapperAbout, withShadow: false)
    }
}

extension ProfileConfigAboutVC {
    // TODO: Implement Setup UI Here
    private func setupUI() {
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = ColorCore.light10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(ProfileConfigAboutCell.self, forCellReuseIdentifier: ProfileConfigAboutCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = ColorCore.red40
        tableView.alwaysBounceVertical = true
        tableView.refreshControl?.addTarget(self, action: #selector(loadAllData), for: .valueChanged)
        view.addSubview(tableView)
        tableView.setConstraintEqualToSuperview(topTo: view.safeAreaLayoutGuide.topAnchor)
    }
    
    @objc private func loadAllData() {
        presenter?.loadAllData()
    }
    
    private func handleErrorState() {
        let isfirstLoadSucceed: Bool = (presenter?.isfirstLoadSucceed).ifNil(false)
        tableView.reloadData()
        if !isfirstLoadSucceed {
            tableView.setupErrorState(title: "", message: "", image: nil, viewState: presenter?.viewState)
        }
    }
}

extension ProfileConfigAboutVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewState = presenter?.viewState, let isfirstLoadSucceed = presenter?.isfirstLoadSucceed else { return 0 }
        let dataTotal = (presenter?.aboutPrivyModels.count).ifNil(0)
        switch viewState {
        case .loading:
            return 5
        case .error:
            return isfirstLoadSucceed ? dataTotal : 0
        default:
            return dataTotal
        }
    }
}

extension ProfileConfigAboutVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewState = presenter?.viewState,
              let cell = tableView.dequeueReusableCell(withIdentifier: ProfileConfigAboutCell.identifier, for: indexPath) as? ProfileConfigAboutCell else { return UITableViewCell() }
        
        let data = presenter?.aboutPrivyModels[safe: indexPath.row]
        cell.selectionStyle = .none
        
        if viewState == .loading {
            cell.startShimmer()
        } else {
            cell.setData(data: data)
            cell.stopShimmer()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (presenter?.viewState).ifNil(.loading) == .success else { return }
        switch indexPath.row {
        case 3:
            presenter?.goToContactUsVC()
        default:
            presenter?.goToWebviewVC(index: indexPath.row)
        }
    }
}

extension ProfileConfigAboutVC: ProfileConfigAboutPresenterToViewProtocol {
    // TODO: Implement View Output Methods
    func showWebviews() {
        tableView.refreshControl?.endRefreshing()
        tableView.backgroundView = nil
        tableView.reloadData()
    }
    
    func handleViewState() {
        tableView.backgroundView = nil
        tableView.refreshControl?.endRefreshing()
        
        guard let viewState = presenter?.viewState else { return }
        switch viewState {
        case .loading:
            tableView.reloadData()
        default:
            handleErrorState()
        }
    }
}
