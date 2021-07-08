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
    var body: some View {
        NavigationView {
            VStack {
                // User Selector
                if let users = viewModel.users {
                    Menu {
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
                    }
                }
                
                // User Info
                if let user = viewModel.user {
                    NavigationLink(destination: {
                        PostListView(user: user)
                    }, label: {
                        Text("My Posts")
                    })
                    Spacer()
                    VStack(alignment: .leading) {
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
                    }
                }
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
