//
//  Books.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

import Foundation

// MARK: - Books
struct Books: Codable {
    let numFound, start: Int
    let docs: [Book]

    enum CodingKeys: String, CodingKey {
        case numFound, start
        case docs
    }
}

// MARK: - Doc
struct Book: Codable {
    let authorKey: [String]?
    let authorName: [String]?
    let coverI: Int64?
    let editionCount: Int?
    let firstPublishYear: Int?
    let language: [String]?
    let title: String
    let subtitle: String?

    enum CodingKeys: String, CodingKey {
        case authorKey = "author_key"
        case authorName = "author_name"
        case coverI = "cover_i"
        case editionCount = "edition_count"
        case firstPublishYear = "first_publish_year"
        case language
        case title, subtitle
    }
}

extension Book {
    
    var coverID: Int64 {
        coverI ?? .zero
    }
    
    var author: String {
        authorName?.first ?? "No-Name"
    }
    
    var posterURL: URL? {
        URL(string: "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg")
    }
    
    init(bookmark: Bookmark) {
        self.title = bookmark.title ?? "No-Name"
        self.authorName = [bookmark.author ?? ""]
        self.coverI = bookmark.coverID
        self.editionCount = Int(bookmark.editions)
        self.authorKey = nil
        self.firstPublishYear = nil
        self.language = nil
        self.subtitle = nil
    }
}
