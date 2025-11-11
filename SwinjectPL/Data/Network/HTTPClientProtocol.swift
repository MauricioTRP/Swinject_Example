//
//  NetworkProtocol.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//

import Foundation

enum NetworkError : String, Error {
    case noInternet,
         notFound,
         unknownError,
         invalidURL,
         decodingError,
         encodingError,
         unauthorized
}

protocol HTTPClientProtocol {
    func send<T: Decodable, E: EndpointProtocol>(_ endpoint: E) async throws -> Result<T, NetworkError>
  
}

