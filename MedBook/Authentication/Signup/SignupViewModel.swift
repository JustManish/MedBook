//
//  SignupViewModel.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//
import SwiftUI
import Combine

extension Country: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
    }

    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.country == rhs.country
    }
}

enum SignupRoute {
    case home
}

class SignupViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var selectedCountry = ""
    @Published var isSignupButtonEnabled = false
    @Published var countriesError: Error? = nil
    @Published var countriesDict: [String: Country] = [:]
    
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil
    
    let navigate: (SignupRoute) -> ()
    
    var countries: [Country] {
        countriesDict.values.map { Country(country: $0.country, countryCode: $0.countryCode) }.sorted {
            $0.country < $1.country
        }
    }

    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Dependency
    private let authService: AuthServiceProtocol
    private let countriesService: CountriesServing

    init(
        service: CountriesServing,
        authService: AuthServiceProtocol,
        navigate: @escaping (SignupRoute) -> ()
    ) {
        self.authService = authService
        self.countriesService = service
        self.navigate = navigate
        
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return email.isValidEmail && password.isValidPassword
            }
            .assign(to: \.isSignupButtonEnabled, on: self)
            .store(in: &cancellables)
    }
    
    @MainActor
    func loadCountries() async {
        countriesError = nil
        guard countries.isEmpty else { return }
        do {
            let countries = try await countriesService.fetchCountries()
            countriesDict = countries.data
        } catch {
            countriesError = error
        }
    }
    
    @MainActor
    func loadCountry() async {
        countriesError = nil
        if let defaultCountry = UserDefaultsManager.getSavedCountry() {
            selectedCountry = defaultCountry
            return
        }

        do {
            let country = try await countriesService.fetchCountry()
            if let countryCode = country.countryCode, let myCountry = countriesDict[countryCode]?.country {
                selectedCountry = myCountry
                UserDefaultsManager.saveCountry(selectedCountry)
            }
        } catch {
            print(error.localizedDescription)
            countriesError = error
        }
    }

    func register() {
        do {
            let lowercasedEmail = email.lowercased()
            try authService.register(email: lowercasedEmail, password: password, country: selectedCountry)
            isAuthenticated = true
            navigate(.home)
            
        } catch let authError as AuthError {
            errorMessage = authError.errorDescription
        } catch {
            errorMessage = "An unexpected error occurred."
        }
    }
}
