//
//  LoginVC.swift
//  elebramtest
//
//  Created by Ahmad Syauqi Albana on 20/07/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBAction func tapLoginButton(_ sender: Any) {
        doLogin()
    }
    
    @IBAction func tapEyeButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        
        let eyeImage = passwordTextField.isSecureTextEntry ? UIImage(named: "ic_eye_close") :
        UIImage(named: "ic_eye_open")
        eyeButton.setImage(eyeImage, for: .normal)
    }
    
    var viewModel: LoginVM = LoginVM()
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerObserver()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func registerObserver() {
        viewModel.token.subscribe(onNext: { [weak self] _ in
            self?.loginSuccess()
        }).disposed(by: disposeBag)
        
        viewModel.error.subscribe(onNext: { [weak self] message in
            self?.stopLoading()
            guard let self = self, let message = message else {
                return
            }
            self.showAlert(message)
        }).disposed(by: disposeBag)
    }
    
    private func startLoading() {
        loadingView.startAnimating()
        loadingContainerView.isHidden = false
        loginButton.isEnabled = false
    }
    
    private func stopLoading() {
        loadingView.stopAnimating()
        loadingContainerView.isHidden = true
        loginButton.isEnabled = true
    }
    
    private func doLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        guard !email.isEmpty else {
            showAlert("Email cant be empty")
            return
        }
        guard isValidEmail(value: email) else {
            showAlert("Email not valid")
            return
        }
        startLoading()
        viewModel.performLogin(email: email, password: password)
    }
    
    private func loginSuccess() {
        stopLoading()
        guard let token = viewModel.token.value else {
            return
        }
        emailTextField.text = ""
        passwordTextField.text = ""
        Session.setToken(token: token)
        Session.setLogin()
        goProfileVC()
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func goProfileVC() {
        let storyboard = UIStoryboard(name: "ProfileVC", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        navigationController?.pushViewController(controller, animated: false)
    }
    
    private func isValidEmail(value: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: value)
    }
}
