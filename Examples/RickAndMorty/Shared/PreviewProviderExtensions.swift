//
//  PreviewProviderExtensions.swift
//  RickAndMorty
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI

extension PreviewProvider {
    static var earth: RickAndMorty.Location {
        return RickAndMorty.Location(name: "Earth", url: "https://rickandmortyapi.com/api/location/1")
    }
    static var rick: RickAndMorty.Character {
        return RickAndMorty.Character(id: 1,
                                      name: "Rick Sanchez",
                                      status: "Alive",
                                      species: "Human",
                                      type: "",
                                      gender: "Male",
                                      image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                      url: "https://rickandmortyapi.com/api/character/1",
                                      created: "2017-11-04T18:48:46.250Z",
                                      location: earth,
                                      origin: earth)
    }
    
    static var morty: RickAndMorty.Character {
        return RickAndMorty.Character(id: 2,
                                      name: "Morty Smith",
                                      status: "Alive",
                                      species: "Human",
                                      type: "",
                                      gender: "Male",
                                      image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                                      url: "https://rickandmortyapi.com/api/character/2",
                                      created: "2017-11-04T18:50:21.651Z",
                                      location: earth,
                                      origin: earth)
    }
}

