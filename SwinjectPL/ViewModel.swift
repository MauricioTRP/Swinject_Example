//
//  ViewModel.swift
//  DependencyInjectionFramework
//
//  Created by Mauricio Fuentes Bravo on 09-11-25.
//
import Foundation
import Swinject

@Observable
class ViewModel {
    private let repo: PostsRepositoryProtocol

    var posts: [PostsModel] = []
    var errorMessage: String?
    
    init(repo: PostsRepositoryProtocol) {
        self.repo = repo
        Task {
            await getPosts()
        }
    }

    private func getPosts() async {
        do {
            let postsResult = try await repo.getPosts()
            
            posts.append(contentsOf: postsResult)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ViewModelFactory {
    let resolver: Resolver
    func make() -> ViewModel {
        ViewModel(repo: resolver.resolve(PostsRepositoryProtocol.self)!)
    }
}
