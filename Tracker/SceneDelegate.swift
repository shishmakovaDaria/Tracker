//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 24.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        if(UserDefaults.standard.bool(forKey: "notFirstTimeInApp") == false) {
            UserDefaults.standard.set(true, forKey: "notFirstTimeInApp")
            let vc = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            window?.rootViewController = vc
        } else {
            window?.rootViewController = TabBarController()
        }
        window?.makeKeyAndVisible()
    }
}

