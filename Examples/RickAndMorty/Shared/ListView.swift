//
//  ListView.swift
//  RickAndMorty
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import SwiftRest

struct ListView: View {
    @ObservedObject var viewModel = ListViewModel()
    var api: AsyncRestRequest
    func nextButton() -> some View {
        print("Loading")
        let buttonText: String
        var color = Color.green
        switch self.viewModel.pagination {
        case .loading:
            buttonText = "Loading..."
            color = .gray
        case .empty:
            buttonText = "Get First Page"
        case .nextPage(let page):
            buttonText = "Get Another Page (\(page))"
        case .complete:
            buttonText = "Completely Loaded"
        }
        return Text(buttonText).foregroundColor(color).padding()
    }
    var columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 1)
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.characters) { character in
                        NavigationLink(destination:                     CharacterView(characterID: character.id)) {
                            ListItemView(character: character)
                        }
                    }
                    Button {
                        switch self.viewModel.pagination {
                        case .loading:
                            // Button masher, do nothing
                            return
                        case .empty:
                            _ = self.api
                                .get()
                        case .nextPage(let page):
                            _ = self.api
                                .addQueryParameter("page", value: page)
                                .get()
                        case .complete:
                            // Completely Loaded, do nothing
                            return
                        }
                    } label: {
                        self.nextButton()
                    }
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Rick and Morty")
        }
    }
    init(api: AsyncRestRequest = AsyncRestRequest(baseURL: RickAndMorty.baseURL)) {
        self.api = api.resource("character")
        _ = api.bind(result: $viewModel.listResult).get()

    }
}

struct ListView_Previews: PreviewProvider {
    static let mockResponse = RickAndMorty.ListResponse(info: .init(count: 2, pages: 1, next: nil, prev: nil),
                                                        results: [rick, morty])
    static let mockAPI = AsyncRestRequest().mock(response: mockResponse)
    static var previews: some View {
        ListView(api: mockAPI)
    }
}
