//
//  Models.swift
//  JsonPlaceholder
//
//  Created by Douglas Pedley on 7/3/21.
//

import Foundation

struct JsonPlaceholder {
    static var baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
}

struct Post: Codable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct Comment: Codable, Identifiable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: Address
    let company: Company
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: GeoLocation
}

struct GeoLocation: Codable {
    let lat: String
    let lng: String
}
