//
//  PostListView.swift
//  JsonPlaceholder
//
//  Created by Douglas Pedley on 7/5/21.
//

import SwiftUI
import SwiftRest

struct PostListView: View {
    let user: User?
    @ObservedObject var viewModel: PostListViewModel
    var api: AsyncRestRequest
    var body: some View {
        List(viewModel.posts ?? []) { post in
            NavigationLink {
                PostView(postId: post.id)
            } label: {
                Text(post.title)
            }

        }
        .navigationTitle(viewModel.title)
    }
    init(api: AsyncRestRequest = AsyncRestRequest(baseURL: JsonPlaceholder.baseURL), user: User? = nil) {
        self.user = user
        self.viewModel = PostListViewModel(user: user)
        self.api = api.resource("posts")
        if let user = user {
            _ = api.addQueryParameter("userId", value: user.id)
        }
        _ = api.bind(success: $viewModel.posts).get()
    }
}

struct PostListView_Previews: PreviewProvider {
    static let posts: [Post] = [
        Post(id: 1, userId: 1, title: "First Title", body: "Some body text"),
        Post(id: 2, userId: 1, title: "Second Title", body: "Some different body text")
    ]
    static let mockAPI = AsyncRestRequest().mock(response: posts)
    static var previews: some View {
        PostListView(api: mockAPI)
    }
}
