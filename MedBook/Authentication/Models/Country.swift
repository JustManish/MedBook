//
//  Country.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import Foundation

// MARK: - Countries
struct Countries: Codable {
    let data: [String: Country]

    enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Country
struct Country: Codable, Identifiable {
    let id = UUID()
    let country: String
    let countryCode: String?
}
