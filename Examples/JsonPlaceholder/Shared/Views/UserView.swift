//
//  UserView.swift
//  JsonPlaceholder
//
//  Created by Douglas Pedley on 7/3/21.
//

import SwiftUI
import SwiftRest

struct UserView: View {
    @ObservedObject var viewModel = UserViewModel()
    var userRequest: AsyncRestRequest
    func userSelector(users: [User]?) -> some View {
        guard let users = users else {
            return AnyView(ProgressView())
        }
        return AnyView(Menu {
            ForEach(users) { user in
                Button {
                    viewModel.user = user
                } label: {
                    Text(user.name)
                }
            }
        } label: {
            Text(viewModel.user?.name ?? "Select User")
            Image(systemName: "menubar.arrow.down.rectangle")
        })
    }
    func posts(user: User?) -> AnyView? {
        guard let user = user else { return nil }
        return AnyView(
            NavigationLink(destination: {
            PostListView(user: user)
        }, label: {
            Text("My Posts")
        })
        )
    }
    func userInfo(user: User?) -> some View {
        guard let user = user else {
            return AnyView(EmptyView())
        }
        return AnyView(VStack(alignment: .leading) {
            Text("\(user.username): \(user.email)")
            Text("Phone: \(user.phone)")
            Text("Website: \(user.website)")
            Spacer().frame(height: 16)
            Text("     \(user.address.street) \(user.address.suite)")
            Text("     \(user.address.city) \(user.address.zipcode)")
            Spacer().frame(height: 16)
            Text("Company: \(user.company.name)")
            Text("         \(user.company.catchPhrase)")
                .font(.footnote)
            Text("         \(user.company.bs)")
                .font(.footnote)
        })
    }
    var body: some View {
        NavigationView {
            VStack {
                userSelector(users: viewModel.users)
                posts(user: viewModel.user)
                Spacer()
                userInfo(user: viewModel.user)
                Spacer()
            }
        }
    }
    init(api: AsyncRestRequest = AsyncRestRequest(baseURL: JsonPlaceholder.baseURL)) {
        self.userRequest = api.resource("users")
        _ = userRequest.bind(success: $viewModel.users).get()
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
