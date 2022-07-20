//
//  ProfileVC.swift
//  elebramtest
//
//  Created by Ahmad Syauqi Albana on 20/07/22.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBAction func tapLogout(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self]  _ in
            Session.setLogout()
            self?.backToRoot()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    var viewModel: ProfileVM = ProfileVM()
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func registerObserver() {
        viewModel.user.subscribe(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.stopLoading()
            self.bindData()
        }).disposed(by: disposeBag)
        
        viewModel.error.subscribe(onNext: { [weak self] _ in
            self?.stopLoading()
        }).disposed(by: disposeBag)
    }
}

extension ProfileVC {
    private func loadAllData() {
        loadingView.startAnimating()
        loadingContainerView.isHidden = false
        viewModel.getProfile()
    }
    
    private func stopLoading() {
        loadingView.stopAnimating()
        loadingContainerView.isHidden = true
    }
    
    private func bindData() {
        let user = viewModel.user.value
        let firstName = (user?.data?.firstName) ?? ""
        let lastName = (user?.data?.lastName) ?? ""
        let fullName = "\(firstName) \(lastName)"
        let email = (user?.data?.email) ?? ""
        nameLabel.text = fullName
        emailLabel.text = email
        
        let avatarURL = (user?.data?.avatar) ?? ""
        let placeholder = UIImage(named: "img_default_profile")
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: URL(string: avatarURL), placeholder: placeholder)
        
        let supportText = (user?.support?.text) ?? ""
        let supportUrl = (user?.support?.url) ?? ""
        supportLabel.text = "\(supportText)\n\(supportUrl)"
    }
    
    private func backToRoot() {
        guard let vc = navigationController?.viewControllers.first(where: { $0 is LoginVC }) as? LoginVC else {
            goLoginVC()
            return
        }
        navigationController?.popToViewController(vc, animated: true)
    }
    
    private func goLoginVC() {
        let storyboard = UIStoryboard(name: "LoginVC", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(controller, animated: false)
    }
}

