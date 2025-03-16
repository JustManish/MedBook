//
//  RequestURN.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//TODO: Can configure for different scheme(Dev, Stage, Prod)
enum BaseURLType {
    case geo
    case openLibrary
    case ipApi
    
    var baseURLString: String {
        switch self {
        case .geo:
            return "https://api.first.org"
        case .openLibrary:
            return "https://openlibrary.org"
        case .ipApi:
            return "http://ip-api.com"
        }
    }
}

//MARK: Represent Network Request
protocol URN {
    associatedtype Derived: Decodable
    var endpoint: Endpoint { get }
    var baseURLType: BaseURLType { get }
    var queryPath: String? { get }
    var method: HTTPMethod { get }
    var parameters: [String : String]? { get }
    var headers: [String : String]? { get }
    var body: Data? { get }
    var urlQueryItems: [URLQueryItem] { get }
}

extension URN {
    var queryPath: String? {
        return nil
    }
    
    var urlQueryItems: [URLQueryItem] {
        let queryItems = parameters?.compactMap({ query in
            URLQueryItem(name: query.key, value: query.value)
        })
        return queryItems ?? []
    }
}

protocol MedBookURN: URN {}

extension MedBookURN {
    
    var method: HTTPMethod {
        return .get
    }
    
    var body: Data? {
        return nil
    }
    
    var headers: [String : String]? {
        switch method {
        case .get:
            return nil
        case .post, .put, .delete:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        }
    }
    
    var parameters: [String : String]? {
        return nil
    }
}

struct CountriesListURN: MedBookURN {
    typealias Derived = Countries
    
    var baseURLType: BaseURLType {
        return .geo
    }
    
    var endpoint: Endpoint {
        return .countries
    }
}

struct CountryURN: MedBookURN {
    typealias Derived = Country
    
    var endpoint: Endpoint {
        return .country
    }
    
    var baseURLType: BaseURLType {
        return .ipApi
    }
}

protocol BooksURN: MedBookURN {}

extension BooksURN {
    
    var baseURLType: BaseURLType {
        return .openLibrary
    }
}

struct BooksSearchURN: BooksURN {
    typealias Derived = Books
    
    var endpoint: Endpoint {
        return .search
    }
    
    var parameters: [String : String]?
}
