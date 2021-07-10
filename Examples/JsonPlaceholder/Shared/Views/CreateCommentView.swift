//
//  CreateCommentView.swift
//  JsonPlaceholder
//
//  Created by Douglas Pedley on 7/6/21.
//

import SwiftUI
import SwiftRest

struct CreateCommentView: View {
    let user: User?
    var createPostRequest: AsyncRestRequest
    @ObservedObject var viewModel = CreateCommentViewModel()
    @FocusState private var textFocus: Bool
    var body: some View {
        VStack {
            Text("Type your comment here")
            TextEditor(text: $viewModel.newComment.body)
                .focused($textFocus)
                .multilineTextAlignment(.leading)
                .border(.gray)
                .task {
                    textFocus = true
                }
            Button {
                _ = createPostRequest.post(body: viewModel.newComment)
            } label: {
                Text("Save")
            }
        }
        .padding()
    }
    init(api: AsyncRestRequest = AsyncRestRequest(baseURL: JsonPlaceholder.baseURL),
         user: User?,
         postId: Int,
         commentId: Int) {
        self.user = user
        self.createPostRequest = api.resource("comments")
        viewModel.newComment.postId = postId
        viewModel.newComment.id = commentId
        viewModel.newComment.name = user?.name ?? "anonymous"
        viewModel.newComment.email = user?.email ?? "noemail"
        _ = createPostRequest.bind(result: $viewModel.result)
    }
}

struct CreateCommentView_Previews: PreviewProvider {
    static let comment = Comment(postId: 1,
                                 id: 10,
                                 name: "User One",
                                 email: "user1@aol.com",
                                 body: "I am commenting.")
    static let mockCreateComment = AsyncRestRequest().mock(response: comment)
    static var previews: some View {
        CreateCommentView(api: mockCreateComment, user: nil, postId: 1, commentId: 10)
    }
}
