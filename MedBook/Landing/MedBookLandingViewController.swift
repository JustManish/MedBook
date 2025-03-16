//
//  MedBookLandingViewController.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import UIKit
import SwiftUI

final class MedBookLandingViewController: UIViewController {
    
    private lazy var embedController: UIHostingController<MedBookLandingRootView> = {
        let controller = UIHostingController(
            rootView: MedBookLandingRootView(
                viewModel: MedBookLandingViewModel(navigateTo: handleNavigation(_:))
            )
        )
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBackground
        configureNavigationBar()
        configureUI()
    }
    
    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: Configure UI
    private func configureUI() {
        add(childViewController: embedController, to: self.view)
    }
    
    private func handleNavigation(_ route: LandingRoute) {
        switch route {
        case .signIn:
            let loginViewController = LoginViewController()
            self.navigationController?.pushViewController(loginViewController, animated: true)
        case .signUp:
            let signupViewController = SignupViewController()
            self.navigationController?.pushViewController(signupViewController, animated: true)
        }
    }
}
