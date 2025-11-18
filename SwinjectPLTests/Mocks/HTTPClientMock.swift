//
//  HTTPClientMock.swift
//  SwinjectPL
//
//  Created by Mauricio Fuentes Bravo on 18-11-25.
//

@testable import SwinjectPL


class HTTPClientMock : HTTPClientProtocol {
    var resultToReturn: Result<Any, NetworkError>?
    var endpointReceived: EndpointProtocol?
    
    func send<T: Decodable, E: EndpointProtocol>(_ endpoint: E) async throws -> Result<T, NetworkError> {
        
        guard let result = resultToReturn else {
            return .failure(.unknownError)
        }
        
        switch result {
        case .success(let success):
            if let typedValue = success as? T {
                return .success(typedValue)
            } else {
                return .failure(.decodingError)
            }
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
