//
//  DataSourceProtocol.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//

import Foundation

protocol DataSourceProtocol {
    func getData() async throws -> Result<[PostsModel], Error>
}
