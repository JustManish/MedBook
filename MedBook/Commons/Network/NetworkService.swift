//
//  NetworkService.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//
import Foundation

protocol NetworkServing {
    func makeRequest<T: URN>(with request: T) async throws -> T.Derived
}

final class NetworkService: NetworkServing {
    
    private let session: URLSession
    
    //MARK: Some time open Api time-out
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15 // Timeout for requests (in seconds)
        config.timeoutIntervalForResource = 30 // Timeout for entire resource
        config.waitsForConnectivity = true // Waits for network if not available
        session = URLSession(configuration: config)
    }

    func makeRequest<T: URN>(with requestURN: T) async throws -> T.Derived {
        var urlComponents = URLComponents(
            string: requestURN.baseURLType.baseURLString + requestURN.endpoint.rawValue
        )

        urlComponents?.queryItems = requestURN.urlQueryItems

        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL // Throw an error if URL is invalid
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = requestURN.method.rawValue
        request.allHTTPHeaderFields = requestURN.headers
        request.httpBody = requestURN.body
        
        debugPrint("request: \(request)")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        let decodedObject: T.Derived = try process(response: data)

        return decodedObject
    }
    
    private func process<T: Decodable>(response: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: response)
        } catch let error {
            throw NetworkError.decodingError(error)
        }
    }
}

// MARK: - Error Handling
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case dataNotFound
    case decodingError(Error)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid. Please try again later."
        case .invalidResponse:
            return "The server response was not as expected. Please check your connection and try again."
        case .httpError(let statusCode):
            return "An error occurred while connecting to the server. (HTTP Status: \(statusCode))"
        case .dataNotFound:
            return "The requested data could not be found. Please try again."
        case .decodingError:
            return "We encountered an issue while processing the data. Please try again later."
        }
    }
}
