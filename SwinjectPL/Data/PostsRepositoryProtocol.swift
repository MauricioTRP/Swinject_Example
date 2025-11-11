//
//  PostsRepositoryProtocol.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//

protocol PostsRepositoryProtocol {
    func getPosts() async throws -> [PostsModel]

    init(localDataSource: DataSourceProtocol, remoteDataSource: HTTPClientProtocol)
}
