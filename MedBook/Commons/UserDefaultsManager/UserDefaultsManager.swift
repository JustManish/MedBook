//
//  UserDefaultsManager.swift
//  MedBook
//
//  Created by Manish Patidar on 16/03/25.
//


import Foundation

class UserDefaultsManager {
    private static let countryKey = "selectedCountry"

    static func saveCountry(_ country: String) {
        UserDefaults.standard.setValue(country, forKey: countryKey)
    }

    static func getSavedCountry() -> String? {
        return UserDefaults.standard.string(forKey: countryKey)
    }
}
