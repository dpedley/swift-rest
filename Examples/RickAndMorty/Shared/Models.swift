//
//  Models.swift
//  RickAndMorty
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI

enum RickAndMorty {
    static let baseURL = URL(string: "https://rickandmortyapi.com/api")!
    struct Character: Codable, Identifiable {
        let id: Int
        let name: String
        let status: String
        let species: String
        let type: String
        let gender: String
        let image: String
        let url: String
        let created: String
        let location: Location
        let origin: Location
    }
    struct Location: Codable {
        let name: String
        let url: String
    }
    struct PaginationInfo: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    struct ListResponse: Codable {
        let info: PaginationInfo
        let results: [RickAndMorty.Character]
    }
}

extension RickAndMorty.Character {
    var summaryDescription: String {
        let genderString = gender == "unknown" ? "" : " \(gender.lowercased())"
        let isWas = status == "Dead" ? "was a" : "is a"
        let n = "aeiouAEIOU".contains(species.first ?? "X") ? "n" : ""
        let locationDetails: String
        if origin.name == location.name {
            if origin.name == "unknown" {
                locationDetails = "whereabouts unknown"
            } else {
                locationDetails = "they can be found on \(origin.name)"
            }
        } else {
            if origin.name == "unknown" {
                locationDetails = "currently on \(location.name), but it is not known where they originally came from"
            } else if location.name == "unknown" {
                locationDetails = "originally from \(origin.name), but it is not known where they can be found"
            } else {
                locationDetails = "originally from \(origin.name), but they currently can be found on \(location.name)"
            }
        }
        return "\(name) \(isWas)\(n) \(species.lowercased())\(genderString) \(locationDetails)."
    }
}

