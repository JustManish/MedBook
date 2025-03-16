//
//  SceneDelegate.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let authService: AuthServiceProtocol = AuthService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootVC = authService.isAuthenticated() ? HomeViewController() : MedBookLandingViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

