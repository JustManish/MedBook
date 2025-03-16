//
//  HomeViewController.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

import UIKit
import SwiftUI

final class HomeViewController: UIViewController {

    private lazy var embedController: UIHostingController<HomeScreenView> = {
        let bookmarksService = DefaultBookmarksService()
        let viewModel = HomeScreenViewModel(
            authService: AuthService(),
            bookmarksService: bookmarksService
        ) { action in
            switch action {
            case .logout:
                let loginVC = LoginViewController()
                self.navigationController?.setViewControllers([loginVC], animated: true)
            case .openBookmarks:
                let bookmarksVC = BookmarksViewController()
                self.navigationController?.pushViewController(bookmarksVC, animated: true)
            }
        }
        let controller = UIHostingController(rootView: HomeScreenView(viewModel: viewModel))
        controller.view.backgroundColor = .primaryBackground
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBackground
        styleNavigationBar()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: Configure UI
    private func configureUI() {
        add(childViewController: embedController, to: self.view)
    }
}
