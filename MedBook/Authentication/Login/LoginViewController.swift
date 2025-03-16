//
//  LoginViewController.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import UIKit
import SwiftUI

final class LoginViewController: UIViewController {

    private lazy var embedController: UIHostingController<LoginRootView> = {
        let userRepository = CoreDataUserRepository()
        let authService = AuthService()
        let viewModel = LoginViewModel(authService: authService, navigateTo: navigate)
        let controller = UIHostingController(rootView: LoginRootView(viewModel: viewModel))
        controller.view.backgroundColor = .primaryBackground
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: false)
        configureUI()
    }
    
    //MARK: Configure UI
    private func configureUI() {
        add(childViewController: embedController, to: self.view)
    }
    
    private func navigate(route: LoginRoute) {
        if case .home(let user) = route {
            let homeViewController = HomeViewController()
            navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}
