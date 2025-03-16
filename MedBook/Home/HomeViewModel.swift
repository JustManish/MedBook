//
//  HomeViewModel.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//
import SwiftUI
import Combine

enum HomeRoute {
    case logout
    case openBookmarks
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}

extension Book: Identifiable {
    //TODO: can be improved
    var id: String {
        "\(title)-\(authorKey?.first ?? "unknown")-\(firstPublishYear ?? 0)"
    }
}

final class HomeScreenViewModel: ObservableObject {
    
    private let service: HomeServing
    private let authService: AuthServiceProtocol
    private let bookmarksService: BookmarksService
    
    private var currentOffset = 0
    private let pageSize = 10
    
    @Published var books: [Book] = []
    @Published var isLoading = false
    @Published var hasMoreData = true
    
    @Published var searchText: String = ""
    @Published var sortBy: SortOption = .title
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?
    
    let performAction: (HomeRoute) -> ()
    
    init(
        authService: AuthServiceProtocol,
        service: HomeServing = HomeService(),
        bookmarksService: BookmarksService,
        performAction: @escaping (HomeRoute) -> ()
    ) {
        self.authService = authService
        self.service = service
        self.bookmarksService = bookmarksService
        self.performAction = performAction
        setupSearchListener()
    }
    
    private func setupSearchListener() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                
                self.searchTask?.cancel()
                if newValue.count >= 3 {
                    self.searchTask = Task {
                        await self.resetAndFetch()
                    }
                } else {
                    self.books.removeAll()
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func resetAndFetch() async {
        currentOffset = 0
        hasMoreData = true
        books.removeAll()
        await fetchMoreBooks()
        sortResults()
    }
    
    @MainActor
    func fetchMoreBooks() async {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        defer { isLoading = false }
        let sanitizedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            let newBooks = try await service.query(sanitizedQuery, offset: currentOffset, limit: pageSize)
            
            guard !Task.isCancelled else { return }
            
            books.append(contentsOf: newBooks.docs)
            
            if newBooks.docs.count < pageSize {
                hasMoreData = false
            } else {
                currentOffset += pageSize
            }
        } catch let error as NetworkError {
            guard !Task.isCancelled else { return }
            errorMessage = error.description
        } catch let error {
            guard !Task.isCancelled else { return }
            errorMessage = "something went wrong, please try again... 😑"
        }
    }
    
    //MARK: Using following options, since response is missing ratings
    enum SortOption: String, CaseIterable, Identifiable {
        case title = "Title"
        case editions = "Editions"
        case publishYear = "Year"
        
        var id: String { self.rawValue }
    }
    
    //MARK: This logic is altered, response is missing ratings
    func sortResults() {
        switch sortBy {
        case .title:
            books.sort { $0.title < $1.title }
        case .editions:
            books.sort { $0.editionCount ?? 0 < $01.editionCount ?? 0 }
        case .publishYear:
            books.sort { $0.firstPublishYear ?? 0 < $1.firstPublishYear ?? 0 }
        }
    }
    
    func isBookmarked(_ book: Book) -> Bool {
        return bookmarksService.checkBookmarkStatus(book)
    }
}

extension HomeScreenViewModel {
    func addToBookmark(book: Book) {
        guard let user = authService.getCurrentUser() else { return }
        do {
            try bookmarksService.addBookmark(for: user, book: book)
        } catch {
            //TODO: Handle Error
        }
    }
    
    func removeBookmark(book: Book) {
        try? bookmarksService.removeBookmark(for: book)
    }
}

extension HomeScreenViewModel {
    func logout() {
        do {
           try authService.logout()
            performAction(.logout)
        } catch {
            print("Error logging out")
        }
    }
}
