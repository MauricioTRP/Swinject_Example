//
//  Assembler.swift
//  SwinjectPL
//
//  Created by Mauricio Fuentes Bravo on 11-11-25.
//

import Foundation
import Swinject

struct NetworkAssembly : Assembly {
    func assemble(container: Swinject.Container) {
        // Base URL
        container.register(URL.self, name: "baseURL") { _ in
            guard let url = URL(string: "https://jsonplaceholder.typicode.com") else {
                fatalError("URL dependency creation failed")
            }
            
            return url
        }.inObjectScope(.container)
        
        container.register(HTTPClientProtocol.self) { resolver in
            guard let baseURL = resolver.resolve(URL.self, name: "baseURL") else {
                preconditionFailure("Base url dependency does not exists")
            }
            return DefaultHTTPClient(baseURL: baseURL)
        }.inObjectScope(.container)
    }
}

struct LocalDataAssembly : Assembly {
    func assemble(container: Swinject.Container) {
        container.register(DataSourceProtocol.self, factory: { _ in
            LocalDataSourceImpl()
        }).inObjectScope(.container)
    }
}

struct RepositoryAssembly : Assembly {
    func assemble(container: Swinject.Container) {
        container.register(PostsRepositoryProtocol.self) { r in
            guard
                let remote = r.resolve(HTTPClientProtocol.self),
                let local = r.resolve(DataSourceProtocol.self)
            else {
                preconditionFailure("Missing registration HttpClientProtocol and/or DataSourceProtocol")
            }
            
            return PostsRepositoryImpl(
                localDataSource: local,
                remoteDataSource: remote
            )
        }.inObjectScope(.container)
    }
}

struct ViewModelAssembly : Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ViewModel.self) { r in
            guard let repo = r.resolve(PostsRepositoryProtocol.self) else {
                preconditionFailure("Missing registration of PostsRepositoryProtocol")
            }
            return ViewModel(repo: repo)
        }
    }
}
