//
//  LocalDataSourceMock.swift
//  SwinjectPL
//
//  Created by Mauricio Fuentes Bravo on 18-11-25.
//

@testable import SwinjectPL

// Isolation
class LocalDataSourceMock: DataSourceProtocol {
    var resultToReturn: Result<[SwinjectPL.PostsModel], any Error> = .success([])
    
    func getData() async throws -> Result<[SwinjectPL.PostsModel], any Error> {
        return resultToReturn
    }
}

