//
//  HomeService.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

// MARK: - HomeServing Protocol
protocol HomeServing {
    func query(_ query: String, offset: Int, limit: Int) async throws -> Books
}

final class HomeService: HomeServing {

    //MARK: Dependency
    private let service: NetworkServing
    
    init(service: NetworkServing = NetworkService()) {
        self.service = service
    }
    
    func query(_ query: String, offset: Int, limit: Int) async throws -> Books {
        let params = [
            "title": query,
            "offset": "\(offset)",
            "limit": "\(limit)",
        ]
        let urn = BooksSearchURN(parameters: params)
        return try await service.makeRequest(with: urn)
    }
}
