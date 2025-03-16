//
//  CountryService.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//



protocol CountriesServing {
    func fetchCountries() async throws -> Countries
    func fetchCountry() async throws -> Country
}

final class CountriesService: CountriesServing {
    //MARK: Dependency
    private let service: NetworkServing
    
    init(service: NetworkServing = NetworkService()) {
        self.service = service
    }
    
    //MARK: Get countries list
    func fetchCountries() async throws -> Countries {
        let urn = CountriesListURN()
        return try await service.makeRequest(with: urn)
    }
    
    //MARK: Get country from IP API
    func fetchCountry() async throws -> Country {
        let urn = CountryURN()
        return try await service.makeRequest(with: urn)
    }
}
