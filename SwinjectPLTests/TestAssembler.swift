//
//  TestAssembler.swift
//  SwinjectPL
//
//  Created by Mauricio Fuentes Bravo on 19-11-25.
//

@testable import SwinjectPL
import Swinject

struct DataSourcesMockAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HTTPClientProtocol.self) { _ in
            return HTTPClientMock()
        }.inObjectScope(.container)
        
        container.register(DataSourceProtocol.self) { _ in
            return LocalDataSourceMock()
        }.inObjectScope(.container)
    }
}

struct PostsRepositoryAssembly : Assembly {
    func assemble(container: Swinject.Container) {
        container.register(PostsRepositoryProtocol.self) { resolver in
            guard let mockHttpClient = resolver.resolve(HTTPClientProtocol.self) else {
                preconditionFailure("no mock http client provided")
            }
            guard let localDataSource = resolver.resolve(DataSourceProtocol.self) else {
                preconditionFailure("No mock local data source provided")
            }
            
            let repo = PostsRepositoryImpl(
                localDataSource: localDataSource,
                remoteDataSource: mockHttpClient
            )

            return repo
        }
    }
}
