//
//  LoginViewModel.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//
import Foundation
import Combine

enum LoginRoute {
    case home(User?)
}

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isLoginButtonEnabled = false
    
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    var navigateTo: (LoginRoute) -> ()
    
    //MARK: Dependency
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol, navigateTo: @escaping (LoginRoute) -> ()) {
        self.authService = authService
        self.navigateTo = navigateTo
        
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return email.isValidEmail && password.isValidPassword
            }
            .assign(to: \.isLoginButtonEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func login() {
        do {
            let lowercasedEmail = email.lowercased()
            let user = try authService.login(email: lowercasedEmail, password: password)
            isAuthenticated = true
            navigateTo(.home(user))
        } catch let authError as AuthError {
            errorMessage = authError.errorDescription
        } catch {
            errorMessage = "An unexpected error occurred."
        }
    }
}
