//
//  CommentView.swift
//  JsonPlaceholder
//
//  Created by Douglas Pedley on 7/6/21.
//

import SwiftUI

struct CommentView: View {
    let comment: Comment
    @State var collapsed = false
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                collapsed.toggle()
            } label: {
                HStack {
                    Image(systemName: collapsed ? "plus.circle" : "minus.circle")
                        .foregroundColor(.gray)
                    if collapsed {
                        Text(comment.email)
                            .font(.caption)
                            .lineLimit(1)
                            .foregroundColor(.blue)
                    }
                    VStack {
                        Divider().padding(.trailing)
                    }
                }
            }

            if collapsed {
                EmptyView()
            } else {
                Text(comment.body)
                Spacer()
                Text(comment.name)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.blue)
                Text(comment.email)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static let comment = Comment(postId: 1,
                                 id: 1,
                                 name: "User One",
                                 email: "user1@aol.com",
                                 body: "I am commenting.")

    static var previews: some View {
        CommentView(comment: comment)
    }
}
