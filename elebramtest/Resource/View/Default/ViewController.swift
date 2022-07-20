//
//  ViewController.swift
//  elebramtest
//
//  Created by Ahmad Syauqi Albana on 20/07/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Session.checkLogin() {
            goProfileVC()
        } else {
            goLoginVC()
        }
    }

    private func goProfileVC() {
        let storyboard = UIStoryboard(name: "ProfileVC", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        navigationController?.pushViewController(controller, animated: false)
    }
    
    private func goLoginVC() {
        let storyboard = UIStoryboard(name: "LoginVC", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(controller, animated: false)
    }
}

