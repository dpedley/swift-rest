//
//  ListItemView.swift
//  RickAndMorty
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import SwiftRest

struct ListItemView: View {
    let character: RickAndMorty.Character
    var body: some View {
        HStack {
            Text(character.name)
            Spacer()
            AsyncImage(url: URL(string: character.image)) { phase in
                if let image = phase.image {
                    image.resizable()
                } else if phase.error != nil {
                    Text("?").font(.title)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 100, height: 100)
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        RickAndMortyListItem(character: rick)
    }
}
