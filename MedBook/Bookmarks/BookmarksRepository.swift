//
//  BookmarksRepository.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//


import Foundation
import CoreData

protocol BookmarksRepository {
    func addBookmark(for user: User, book: Book) throws
    func removeBookmark(_ bookmark: Bookmark) throws
    func removeBookmark(for book: Book) throws
    func fetchBookmarks(for user: User) throws -> [Bookmark]
    func checkBookmarkStatus(book: Book) -> Bool
}

final class CoreDataBookmarksRepository: BookmarksRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func addBookmark(for user: User, book: Book) throws {
        let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookID == %@ AND user == %@", book.id, user)

        let existingBookmarks = try context.fetch(fetchRequest)
        
        guard existingBookmarks.isEmpty else {
            throw BookmarksError.bookmarkAlreadyExists
        }

        let bookmark = Bookmark(context: context)
        bookmark.bookID = book.id
        bookmark.coverID = book.coverID
        bookmark.title = book.title
        bookmark.author = book.authorName?.joined(separator: ", ")
        bookmark.user = user

        try context.save()
    }
    
    func checkBookmarkStatus(book: Book) -> Bool {
        let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookID == %@", book.id)
        do {
            let bookmarks = try context.fetch(fetchRequest)
            return !bookmarks.isEmpty
        } catch {
            return false
        }
    }
    
    func removeBookmark(_ bookmark: Bookmark) throws {
        context.delete(bookmark)
        try saveContext()
    }
    
    func removeBookmark(for book: Book) throws {
        let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookID == %@", book.id)

        do {
            if let bookmark = try context.fetch(fetchRequest).first {
                context.delete(bookmark)
                try saveContext()
            }
        } catch {
            throw error
        }
    }
    
    func fetchBookmarks(for user: User) throws -> [Bookmark] {
        let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        return try context.fetch(fetchRequest)
    }
    
    private func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
