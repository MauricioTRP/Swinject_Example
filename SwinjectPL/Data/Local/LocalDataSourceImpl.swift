//
//  LocalDataSourceImpl.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//

/// A Dummy class to get `PostsRepositoryImpl` workin
class LocalDataSourceImpl : DataSourceProtocol {
    let dummyPosts: [PostsModel] = [
        .init(userId: 1500, id: 1500, title: "My Custom Title 1500", body: "The posts number 1500"),
        .init(userId: 1500, id: 1501, title: "My Custom Title 1501", body: "The posts number 1501"),
        .init(userId: 1500, id: 1502, title: "My Custom Title 1502", body: "The posts number 1502"),
        .init(userId: 1500, id: 1503, title: "My Custom Title 1503", body: "The posts number 1503"),
        .init(userId: 1500, id: 1504, title: "My Custom Title 1504", body: "The posts number 1504"),
    ]
    
    func getData() async throws -> Result<[PostsModel], any Error> {
        return .success(dummyPosts)
    }
}
