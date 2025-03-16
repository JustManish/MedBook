//
//  BookmarksView.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

import SwiftUI

struct BookmarksView: View {
    
    @StateObject var viewModel: BookmarksViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Bookmarks")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black)
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                resultsListView
            }
        }
        .task {
            viewModel.loadBookmarks()
        }
        .padding()
    }
    
    private var resultsListView: some View {
        List {
            ForEach(viewModel.bookmarks, id: \.id) { bookmark in
                BookItemView(book: Book(bookmark: bookmark))
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .background(.primaryBackground)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            viewModel.removeBookmark(bookmark)
                        } label: {
                            Image(.removeBookmark)
                        }
                        .tint(.clear)
                    }
            }
        }
        .background(.primaryBackground)
        .listStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    BookmarksView(viewModel: .init(authService: AuthService()))
}
