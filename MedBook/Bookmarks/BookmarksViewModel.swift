//
//  BookmarksViewModel.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//
import Foundation
import Combine

final class BookmarksViewModel: ObservableObject {
    @Published private(set) var bookmarks: [Bookmark] = []
    @Published var errorMessage: String?
    
    private let bookmarksService: BookmarksService
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol, bookmarksService: BookmarksService = DefaultBookmarksService()) {
        self.authService = authService
        self.bookmarksService = bookmarksService
    }
    
    func loadBookmarks() {
        do {
            guard let user = authService.getCurrentUser() else { return }
            bookmarks = try bookmarksService.fetchBookmarks(for: user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func removeBookmark(_ bookmark: Bookmark) {
        do {
            try bookmarksService.removeBookmark(bookmark)
            loadBookmarks()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
