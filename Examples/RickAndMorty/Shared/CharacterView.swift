//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import SwiftRest

struct CharacterView: View {
    @State var character: RickAndMorty.Character?
    let api: AsyncRestRequest
    var requestedAPI = false
    func characterView(_ currentCharacter: RickAndMorty.Character?) -> some View {
        guard let character = currentCharacter else {
            _ = api.bind(success: $character).get()
            return AnyView(ProgressView())
        }
        let stackView = GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    Text(character.name)
                        .font(.title)
                        .bold()
                    AsyncImage(url: URL(string: character.image)!) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else if phase.error != nil {
                            Text("?").font(.title)
                        } else {
                            ProgressView()
                        }
                    }
                    Text(character.summaryDescription)
                }
                .frame(width: geometry.size.width - 32)
            }
            .frame(width: geometry.size.width)
        }
        return AnyView(stackView)
    }
    var body: some View {
        characterView(character)
    }
    init(characterID: Int) {
        self.api = AsyncRestRequest(baseURL: RickAndMorty.baseURL)
            .resource("character/\(characterID)")
    }
    init(character: RickAndMorty.Character) {
        self.api = AsyncRestRequest(baseURL: RickAndMorty.baseURL)
            .mock(response: character)
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(character: rick)
    }
}
