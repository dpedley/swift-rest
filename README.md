# swift-rest

Swift REST is a library that aims to add REST like functionality to SwiftUI view creation. The main class is `AsyncRestRequest` which allows you to build URLSessions and Bind them to a quick example might help.

```
// Let's assume we have a service that returns JSON like:
// { "user" : "Doug", "country" : "USA" }

struct MyServiceResponse: Codable {
    let user: String
    let country: String
}

struct MyUserView: View {
    @State var response: MyServiceResponse?
    let api: AsyncRestRequest
    var body: some View {
        VStack {
            Text(response?.name ?? "Loading...")
            Text(response?.country ?? "")
        }
    }
    init(_ baseURL: URL) {
        self.api = AsyncRestRequest(baseURL: baseURL)
        api.bind($response).get()
    }
}

```
