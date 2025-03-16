//
//  CoreDataStack.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MedBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
