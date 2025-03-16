//
//  BookmarksError.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//


import Foundation
import CoreData

enum BookmarksError: Error {
    case bookmarkAlreadyExists
    case bookmarkNotFound
    case failedToSave
    case failedToFetch

    var localizedDescription: String {
        switch self {
        case .bookmarkAlreadyExists:
            return "This book is already bookmarked."
        case .failedToSave:
            return "Failed to save bookmark"
        case .bookmarkNotFound:
            return "No book found"
        case .failedToFetch:
            return "Failed to fetch bookmark"
        }
    }
}

protocol BookmarksService {
    func addBookmark(for user: User, book: Book) throws
    func removeBookmark(_ bookmark: Bookmark) throws
    func removeBookmark(for book: Book) throws
    func fetchBookmarks(for user: User) throws -> [Bookmark]
    func checkBookmarkStatus(_ book: Book) -> Bool
}

final class DefaultBookmarksService: BookmarksService {
    private let repository: BookmarksRepository
    
    init(repository: BookmarksRepository = CoreDataBookmarksRepository()) {
        self.repository = repository
    }
    
    func checkBookmarkStatus(_ book: Book) -> Bool {
        return repository.checkBookmarkStatus(book: book)
    }
    
    func addBookmark(for user: User, book: Book) throws {
        do {
            try repository.addBookmark(for: user, book: book)
        } catch {
            throw BookmarksError.failedToSave
        }
    }
    
    func removeBookmark(_ bookmark: Bookmark) throws {
        do {
            try repository.removeBookmark(bookmark)
        } catch {
            throw BookmarksError.bookmarkNotFound
        }
    }
    
    func removeBookmark(for book: Book) throws {
        do {
            try repository.removeBookmark(for: book)
        } catch {
            throw BookmarksError.bookmarkNotFound
        }
    }
    
    func fetchBookmarks(for user: User) throws -> [Bookmark] {
        do {
            return try repository.fetchBookmarks(for: user)
        } catch {
            throw BookmarksError.failedToFetch
        }
    }
}
