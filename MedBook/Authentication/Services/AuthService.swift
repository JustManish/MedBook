//
//  AuthService.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case userAlreadyExists
    case invalidCredentials
    case userNotFound
    case userNotLoggedIn
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .userAlreadyExists:
            return "A user with this email already exists."
        case .invalidCredentials:
            return "Invalid email or password."
        case .userNotFound:
            return "User not found."
        case .userNotLoggedIn:
            return "No user is currently logged in."
        case .unknownError(let message):
            return message
        }
    }
}

protocol AuthServiceProtocol {
    func register(email: String, password: String, country: String) throws
    func login(email: String, password: String) throws -> User?
    func logout() throws
    func getCurrentUser() -> User?
    func isAuthenticated() -> Bool
}

final class AuthService: AuthServiceProtocol {
    private let userRepository: UserRepository

    init(userRepository: UserRepository = CoreDataUserRepository()) {
        self.userRepository = userRepository
    }

    /// Registers a new user
    func register(email: String, password: String, country: String) throws {
        do {
            try userRepository.createUser(email: email, password: password, country: country)
        } catch {
            throw AuthError.userAlreadyExists
        }
    }

    /// Logs in the user
    func login(email: String, password: String) throws -> User? {
        do {
            guard let user = try userRepository.authenticateUser(email: email, password: password) else {
                throw AuthError.invalidCredentials
            }
            return user
        } catch {
            throw AuthError.unknownError(error.localizedDescription)
        }
    }

    /// Logs out the user
    func logout() throws {
        guard let user = userRepository.getLoggedInUser() else {
            throw AuthError.userNotLoggedIn
        }
        try userRepository.logoutUser(email: user.email ?? "")
    }

    /// Retrieves the currently logged-in user
    func getCurrentUser() -> User? {
        return userRepository.getLoggedInUser()
    }

    /// Checks if user is authenticated
    func isAuthenticated() -> Bool {
        return getCurrentUser() != nil
    }
}
