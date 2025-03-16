//
//  UserRepository.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import Foundation
import CoreData

protocol UserRepository {
    func createUser(email: String, password: String, country: String) throws
    func authenticateUser(email: String, password: String) throws -> User?
    func logoutUser(email: String) throws
    func getLoggedInUser() -> User?
}

final class CoreDataUserRepository: UserRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func createUser(email: String, password: String, country: String) throws {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(User.email), email)

        let existingUsers = try context.fetch(fetchRequest)

        if !existingUsers.isEmpty {
            throw AuthError.userAlreadyExists
        }

        let newUser = User(context: context)
        newUser.email = email
        newUser.password = password
        newUser.loggedIn = true
        newUser.country = country

        try CoreDataStack.shared.saveContext()
    }

    func authenticateUser(email: String, password: String) throws -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(User.email), email, #keyPath(User.password), password)

        let users = try context.fetch(fetchRequest)

        if let user = users.first {
            user.loggedIn = true
            try CoreDataStack.shared.saveContext()
            return user
        } else {
            return nil
        }
    }

    func logoutUser(email: String) throws {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(User.email), email)

        if let user = try context.fetch(fetchRequest).first {
            user.loggedIn = false
            try CoreDataStack.shared.saveContext()
        }
    }

    func getLoggedInUser() -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(User.loggedIn), NSNumber(value: true))
        
        return try? context.fetch(fetchRequest).first
    }
}
