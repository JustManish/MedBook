//
//  BookmarksViewController.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

import UIKit
import SwiftUI

class BookmarksViewController: UIViewController {
    
    private lazy var embedController: UIHostingController<BookmarksView> = {
        let viewModel = BookmarksViewModel(authService: AuthService())
        let controller = UIHostingController(rootView: BookmarksView(viewModel: viewModel))
        controller.view.backgroundColor = .primaryBackground
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBackground
        styleNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: false)
        configureUI()
    }
    
    //MARK: Configure UI
    private func configureUI() {
        add(childViewController: embedController, to: self.view)
    }
}
