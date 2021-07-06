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
    func comments(comments: [Comment]?) -> AnyView? {
        guard let comments = comments else { return nil }
        return AnyView(
            ForEach(comments) { comment in
                VStack {
                    Text(comment.body)
                    Text("\(comment.name): \(comment.email)")
                        .font(.caption)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8).stroke()
                )
            }
        )
    }
    var body: some View {
        VStack {
            postBody(post: viewModel.post)
            Spacer()
            comments(comments: viewModel.comments)
        }
        .navigationTitle(viewModel.title)
    }
    init(postRequest: AsyncRestRequest = AsyncRestRequest(baseURL: JsonPlaceholder.baseURL),
         commentsRequest: AsyncRestRequest = AsyncRestRequest(baseURL: JsonPlaceholder.baseURL),
         user: User? = nil, postId: Int) {
        self.user = user
        self.postId = postId
        self.viewModel = PostViewModel()
        self.postRequest = postRequest.resource("posts/\(postId)")
        self.commentsRequest = commentsRequest.resource("comments/\(postId)")
        _ = postRequest.bind(success: $viewModel.post).get()
        _ = commentsRequest.bind(success: $viewModel.comments).get()
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
