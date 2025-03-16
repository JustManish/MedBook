//
//  UIViewController+Extension.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import UIKit

extension UIViewController {
    
    func styleNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    func add(childViewController viewController: UIViewController, to contentView: UIView, shouldIgnoreSafeArea: Bool = true) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: shouldIgnoreSafeArea ? contentView.topAnchor : contentView.safeAreaLayoutGuide.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: shouldIgnoreSafeArea ? contentView.bottomAnchor : contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
        viewController.didMove(toParent: self)
    }
    
    func removeSelfAsChildViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func removeAllChildren() {
        children.forEach { child in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}
