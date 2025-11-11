//
//  PostsRepositoryImpl.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//
import Foundation

@Observable
class PostsRepositoryImpl : PostsRepositoryProtocol {
    private let networkClient: HTTPClientProtocol
    private let localDataSource: any DataSourceProtocol

    required init(
        localDataSource: any DataSourceProtocol,
        remoteDataSource: any HTTPClientProtocol
    ) {
        self.networkClient = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getPosts() async throws -> [PostsModel] {
        let postsResult: Result<[PostsModel], NetworkError> = try await networkClient.send(PostsRemoteResourcesEndpoints.posts())

        switch postsResult {
        case .success(let posts):
            return posts
        case .failure(let error):
            throw error
        }
    }
}
