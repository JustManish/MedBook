//
//  SignupViewController.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import UIKit
import SwiftUI

final class SignupViewController: UIViewController {

    private lazy var embedController: UIHostingController<SignupRootView> = {
        let service = CountriesService()
        let authService = AuthService()
        let viewModel = SignupViewModel(service: service, authService: authService) { route in
            let homeVC = HomeViewController()
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        let controller = UIHostingController(rootView: SignupRootView(viewModel: viewModel))
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
        add(childViewController: embedController, to: self.view, shouldIgnoreSafeArea: true)
    }
}
