//
//  DefaultHTTPClient.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//

import Foundation

/// A client for a "single" API that uses a common [baseUrl]
///
/// Usage Example:
/// ```swift
/// let client = DefaultHTTPClient("https://myBaseUrl")
/// client.get()
///
/// ```
class DefaultHTTPClient: HTTPClientProtocol {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    /**
    This initialized allows to start a Network Client for an API with a common base url as String
     
     - parameter urlString: The url as string for an API
     - throws: `NetworkError.invalidUrl` representing an issue with
     */
    convenience init(urlString: String) throws {
        self.init(baseURL: try DefaultHTTPClient.parseURL(urlString))
    }

    func send<T, E>(_ endpoint: E) async throws -> Result<T, NetworkError> where T : Decodable, E : EndpointProtocol {
        do {
            var request = try buildRequest(from: endpoint)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse else {
                return .failure(.unknownError)
            }
            
            switch http.statusCode {
            case 200...299:
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    return .success(decoded)
                } catch {
                    return .failure(.decodingError)
                }
            case 401:
                return .failure(.unauthorized)
            case 404:
                return .failure(.notFound)
            default:
                return .failure(.unknownError)
            }
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            if (error as NSError).domain == NSURLErrorDomain {
                return .failure(.noInternet)
            }
            return .failure(.unknownError)
        }
    }
    
    // MARK: Private methods
    private static func parseURL(_ urlString: String) throws -> URL {
        guard let url = URL(string: urlString),
              let scheme = url.scheme?.lowercased(),
              let host = url.host,
              ["http", "https"].contains(scheme),
              !host.isEmpty else {
            throw NetworkError.invalidURL
        }
        
        return url
    }

    private func buildRequest<E: EndpointProtocol>(from endpoint: E) throws -> URLRequest {
            // Start with base components
            guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
                throw NetworkError.invalidURL
            }

            // Split path into path + query (supports "/posts?userId=1")
            let rawPath = endpoint.path
            var purePath = rawPath
            var queryFromPath: [URLQueryItem] = []
            if let comps = URLComponents(string: rawPath), comps.scheme == nil, comps.host == nil {
                purePath = comps.path
                if let qs = comps.queryItems { queryFromPath = qs }
            }

            // Merge paths safely
            let appendedPath = purePath.hasPrefix("/") ? purePath : "/" + purePath
            components.path = (components.path as NSString).appendingPathComponent(appendedPath).replacingOccurrences(of: "//", with: "/")

            // Merge query items (path first, then endpoint.query)
            let mergedQuery = (queryFromPath + endpoint.query)
            components.queryItems = mergedQuery.isEmpty ? nil : mergedQuery

            guard let url = components.url else { throw NetworkError.invalidURL }

            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue

            // Headers
            endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

            // Body (if the endpoint provides one)
            if let provider = endpoint as? AnyBodyProvider {
                if let bodyData = try provider.encodedBody() {
                    if request.value(forHTTPHeaderField: "Content-Type") == nil {
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    }
                    request.httpBody = bodyData
                }
            }

            return request
        }
}
