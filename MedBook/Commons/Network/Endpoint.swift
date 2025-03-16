//
//  Endpoint.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

enum Endpoint {
    case countries // Get List of Countries
    case country //Get Country from IP to set selected
    case search
    
    var rawValue: String {
        switch self {
        case .countries:
            return "/data/v1/countries"
        case .search:
            return "/search.json"
        case .country:
            return "/json"
        }
    }
}
