//
//  PostsModel.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//
import Foundation

struct PostsModel : Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
