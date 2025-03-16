//
//  BookItemView.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//
import SwiftUI
import Kingfisher

struct BookItemView: View {
    let book: Book

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            bookImage
                .padding()
            VStack(alignment: .leading) {
                Text(book.title)
                    .lineLimit(1)
                    .font(.headline)
                    .foregroundColor(.black)
                HStack {
                    Text(book.authorName?.first ?? "No-Name")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                    if let editionCount = book.editionCount {
                        Label("\(editionCount, specifier: "%.1f")", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    if let authorsCount = book.authorName?.count {
                        Text("(\(authorsCount))")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.trailing, 8)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.vertical, 8)
    }
    
    private var bookImage: some View {
        KFImage(book.posterURL)
            .resizable()
            .placeholder {
                ProgressView()
            }
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .frame(width: 50, height: 70)
    }
}
