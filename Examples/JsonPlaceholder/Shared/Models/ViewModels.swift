//
//  ViewModels.swift
//  JsonPlaceholder
//
//  Created by Douglas Pedley on 7/3/21.
//

import Foundation

enum LoadingState {
    case loading
    case complete
}

class UserViewModel: ObservableObject {
    @Published var users: [User]? {
        didSet {
            guard let users = users, !users.isEmpty else { return }
            guard user == nil else { return }
            user = users.first
        }
    }
    @Published var user: User?
}

class PostListViewModel: ObservableObject {
    @Published var posts: [Post]?
    var user: User?
    var title: String {
        user?.name ?? "Posts"
    }
    init(user: User?) {
        self.user = user
    }
}

class PostViewModel: ObservableObject {
    @Published var post: Post? {
        didSet {
            guard let post = post else { return }
            self.title = post.title
        }
    }
    @Published var comments: [Comment]?
    @Published var title = "Loading Post"
}
