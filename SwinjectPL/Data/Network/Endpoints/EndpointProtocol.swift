//
//  EndpointProtocol.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//

import Foundation

public protocol EndpointProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [URLQueryItem] { get }
    var headers: [String: String] { get }
}

public enum HTTPMethod: String {
    case GET, POST, PUT, PATH, DELETE, HEAD
}

public protocol AnyBodyProvider {
    func encodedBody() throws -> Data?
}

public struct JSONPlaceholderEndpoint<B: Encodable>: EndpointProtocol {
    public var path: String
    public var method: HTTPMethod
    public var query: [URLQueryItem]
    public var headers: [String : String]
    public var body: B?
    
    public init(path: String,
                method: HTTPMethod = .GET,
                query: [URLQueryItem] = [],
                headers: [String: String] = [:],
                body: B? = nil) {
        self.path = path
        self.body = body
        self.method = method
        self.query = query
        self.headers = headers
    }
}

extension JSONPlaceholderEndpoint : AnyBodyProvider {
    public func encodedBody() throws -> Data? {
        guard let body = body else { return nil }
        do { return try JSONEncoder().encode(body) }
        catch {
            #if DEBUG
            print(error)
            #endif
            
            throw NetworkError.encodingError(error)
        }
    }
}

public struct EmptyBody: Encodable {}

public enum PostsRemoteResourcesEndpoints {
    public static func posts() ->
    JSONPlaceholderEndpoint<EmptyBody> {
        JSONPlaceholderEndpoint(path: "/posts")
    }
    
    public static func postByUser(userId: Int) ->
    JSONPlaceholderEndpoint<EmptyBody> {
        JSONPlaceholderEndpoint(path: "/posts?userId=\(userId)")
    }

    public static func commentsByPost(postId: Int) ->
    JSONPlaceholderEndpoint<EmptyBody> {
        JSONPlaceholderEndpoint(path: "/posts/\(postId)/comments")
    }

    public static func postById(id: Int) ->
    JSONPlaceholderEndpoint<EmptyBody> {
        JSONPlaceholderEndpoint(path: "/posts/\(id)")
    }

    public static func updatePost<T: Encodable>(postId: Int, postBody: T) ->
    JSONPlaceholderEndpoint<T> {
        JSONPlaceholderEndpoint(
            path: "posts/\(postId)",
            method: .POST,
            body: postBody,
        )
    }
}
