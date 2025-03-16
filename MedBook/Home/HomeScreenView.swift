//
//  HomeView.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

import SwiftUI

struct HomeScreenView: View {
    @FocusState private var isSearchFieldFocused: Bool
    @ObservedObject var viewModel: HomeScreenViewModel

    var body: some View {
        VStack(alignment: .leading) {
            headerView
            Text("Which topic interests\nyou today?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black)
            
            
            SearchBar(text: $viewModel.searchText)
                .focused($isSearchFieldFocused)
            
            if !viewModel.books.isEmpty {
                sortOptionsView
            }
            
            if viewModel.isLoading && viewModel.books.isEmpty {
                ProgressView("Searching...")
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top)
            } else {
                resultsListView
                if viewModel.isLoading {
                    ProgressView("Loading more books...")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            Spacer()
        }
        .onReceive(viewModel.$books, perform: { books in
            if !books.isEmpty, isSearchFieldFocused {
                isSearchFieldFocused = false
            }
        })
        .padding()
    }
    
    private var headerView: some View {
        HStack {
            HStack {
                Image(systemName: "book.closed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("MedBook")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .foregroundColor(.black)
            Spacer()
            HStack(spacing: 8) {
                bookMarkButton
                logoutButton
            }
        }
    }
    
    private var logoutButton: some View {
        Button {
            viewModel.logout()
        } label: {
            Image(systemName: "xmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
        }
    }
    
    private var bookMarkButton: some View {
        Button {
            viewModel.performAction(.openBookmarks)
        } label: {
            Image(systemName: "bookmark.fill") // Bookmark icon
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
        }
    }

    private var sortOptionsView: some View {
        HStack {
            Text("Sort By:")
                .foregroundStyle(.black)
            Picker("Sort By", selection: $viewModel.sortBy) {
                ForEach(HomeScreenViewModel.SortOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            Spacer()
        }
        .onChange(of: viewModel.sortBy) { _ in
            viewModel.sortResults()
        }
    }

    private var resultsListView: some View {
        List {
            ForEach(viewModel.books, id: \.id) { book in
                BookItemView(book: book)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            if viewModel.isBookmarked(book) {
                                viewModel.removeBookmark(book: book)
                            } else {
                                viewModel.addToBookmark(book: book)
                            }
                        } label: {
                            Image(viewModel.isBookmarked(book) ? .removeBookmark : .addBookmark)
                        }
                        .tint(.clear)
                    }
                    .onAppear{
                        guard let lastBook = viewModel.books.last, book == lastBook else {
                            return
                        }
                        Task {
                            await viewModel.fetchMoreBooks()
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .background(.primaryBackground)
            }
        }
        .background(.primaryBackground)
        .listStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeScreenView(viewModel: .init(authService: AuthService(), bookmarksService: DefaultBookmarksService(), performAction: { _ in
    }))
}
