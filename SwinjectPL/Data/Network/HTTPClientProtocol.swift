//
//  NetworkProtocol.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//

import Foundation

enum NetworkError : Error {
    case noInternet,
         notFound,
         unknownError(Error),
         invalidURL,
         decodingError(Error),
         encodingError(Error),
         unauthorized,
         networkError,
         timeout
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL Constructed"
        case .noInternet:
            return "No Internet Connection"
        case .notFound:
            return "Resource Not Found"
        case .unknownError(let error):
            return "Unknown error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Enconding error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access"
        case .networkError:
            return "Network error occurred"
        case .timeout:
            return "Request timed out"
        }
    }
}

protocol HTTPClientProtocol {
    func send<T: Decodable, E: EndpointProtocol>(_ endpoint: E) async throws -> Result<T, NetworkError>
  
}

