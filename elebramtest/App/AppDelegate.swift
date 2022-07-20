//
//  AppDelegate.swift
//  elebramtest
//
//  Created by Ahmad Syauqi Albana on 20/07/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        toViewController()
        return true
    }
    
    func toViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isTranslucent = false
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

