//
//  PostView.swift
//  JsonPlaceholder
//
//  Created by Douglas Pedley on 7/5/21.
//

import SwiftUI
import SwiftRest

struct PostView: View {
    let user: User?
    let postId: Int
    @ObservedObject var viewModel: PostViewModel
    var postRequest: AsyncRestRequest
    var commentsRequest: AsyncRestRequest
    func postBody(post: Post?) -> AnyView? {
        guard let post = post else { return nil }
        return AnyView(
            Text(post.title)
        )
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                postBody(post: viewModel.post)
                Spacer()
                ForEach(viewModel.comments ?? []) { comment in
                    CommentView(comment: comment)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(viewModel.title)
        .navigationBarItems(trailing:
            NavigationLink(destination: {
                CreateCommentView(user: user,
                                  postId: postId,
                                  commentId: (viewModel.comments?.count ?? 0) + 1)
            }, label: {
                Image(systemName: "plus.bubble")
            })
        )
        .onAppear {
            _ = postRequest.get()
            _ = commentsRequest.get()
        }
    }
    init(postRequest: AsyncRestRequest = AsyncRestRequest(baseURL: JsonPlaceholder.baseURL),
         commentsRequest: AsyncRestRequest = AsyncRestRequest(baseURL: JsonPlaceholder.baseURL),
         user: User? = nil, postId: Int) {
        self.user = user
        self.postId = postId
        self.viewModel = PostViewModel()
        self.postRequest = postRequest.resource("posts/\(postId)")
        self.commentsRequest = commentsRequest.resource("comments").addQueryParameter("postId", value: postId)
        _ = postRequest.bind(success: $viewModel.post)
        _ = commentsRequest.bind(success: $viewModel.comments)
    }
}

struct PostView_Previews: PreviewProvider {
    static let aPost = Post(id: 1, userId: 1, title: "aTitle", body: "Some body text")
    static let mockPost = AsyncRestRequest().mock(response: aPost)
    static let comments: [Comment] = [
        Comment(postId: 1, id: 1, name: "User One", email: "user1@aol.com", body: "I am commenting."),
        Comment(postId: 1, id: 2, name: "User Two", email: "user2@aol.com", body: "I am also commenting.")
    ]
    static let mockComments = AsyncRestRequest().mock(response: comments)
    static var previews: some View {
        PostView(postRequest: mockPost, commentsRequest: mockComments, postId: 1)
    }
}
