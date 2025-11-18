//
//  PostsRepositoryTests.swift
//  SwinjectPLTests
//
//  Created by Mauricio Fuentes Bravo on 18-11-25.
//

import Testing
@testable import SwinjectPL

struct PostsRepositoryTests {

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

}
