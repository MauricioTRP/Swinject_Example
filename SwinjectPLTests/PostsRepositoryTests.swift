//
//  PostsRepositoryTests.swift
//  SwinjectPLTests
//
//  Created by Mauricio Fuentes Bravo on 18-11-25.
//

import Testing
@testable import SwinjectPL
import Swinject

@Suite("Posts Repo tests")
struct PostsRepositoryTests {
    private var postsRepo: PostsRepositoryProtocol? = nil
    private var mockHttpClient: HTTPClientMock? = nil
    private var mockDataSource: LocalDataSourceMock? = nil
    
    init() async throws {
        let assembler = Assembler([ PostsRepositoryAssembly(), DataSourcesMockAssembly() ])
        self.postsRepo = assembler.resolver.resolve(PostsRepositoryProtocol.self)!
        self.mockDataSource = assembler.resolver.resolve(DataSourceProtocol.self)! as? LocalDataSourceMock
        self.mockHttpClient = assembler.resolver.resolve(HTTPClientProtocol.self)! as? HTTPClientMock
    }


    @Test("PostsRepository - it should return a list of posts when success network call")
    func testPostsRepository_itShouldReturnAListOfPostsWhenSuccessNetworkCall() async throws {
        // Arrange - When
        let mockPosts: [PostsModel] = [
            .init(userId: 1, id: 1, title: "Title 1", body: "Body 1"),
            .init(userId: 2, id: 2, title: "Title 2", body: "Body 2"),
        ]
        
        let mockHTTPClient = HTTPClientMock()
        mockHTTPClient.resultToReturn = .success(mockPosts)
        
        let mockDataSource = LocalDataSourceMock()
        mockDataSource.resultToReturn = .success([])
        
        // Act - Then
        let repository = PostsRepositoryImpl(
            localDataSource: mockDataSource,
            remoteDataSource: mockHTTPClient
        )
        
        let returnedPosts = try? await repository.getPosts()
        
        
        // Assert - Expect
        #expect(returnedPosts != nil)
        #expect(returnedPosts?.count == 2)
        #expect(returnedPosts?.first?.title == "Title 1")
    }

    @Test("Dummy Test")
    func testPostsRepository_dummyTest() async throws {
        // Arrange - Given
        let mockPosts: [PostsModel] = [
            .init(userId: 1, id: 1, title: "Title 1", body: "Body 1"),
            .init(userId: 2, id: 2, title: "Title 2", body: "Body 2")
        ]
        mockHttpClient?.resultToReturn = .success(mockPosts)
        mockDataSource?.resultToReturn = .success([])
        
        // Act - When
        let returnedPosts = try await postsRepo?.getPosts()
        
        // Assert - Then
        #expect(returnedPosts != nil)
        #expect(returnedPosts?.count == 2)
        #expect(returnedPosts?.first?.title == "Title 1")
    }
}
