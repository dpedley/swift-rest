//
//  AsyncRestRequest+Methods.swift
//  
//
//  Created by Douglas Pedley on 7/10/21.
//

import SwiftUI
import Combine

/// These are the public methods for the `REST METHOD` types `GET,POST,PUT,DELETE`.
extension AsyncRestRequest {
    public func get() -> Self {
        return processRequest(method: "GET", httpBody: nil)
    }
    public func delete() -> Self {
        return processRequest(method: "DELETE", httpBody: nil)
    }
    public func post<Body: Encodable>(body: Body? = nil, mockResponse: Bool = false) -> Self {
        guard let body = body else {
            if mockResponse {
                fatalError("Cannot mock response, none given.")
            }
            return processRequest(method: "POST", httpBody: nil)
        }
        do {
            let encoder = JSONEncoder()
            let httpBody = try encoder.encode(body)
            if mockResponse {
                guard let body = body as? Codable else {
                    fatalError("Cannot mock response from body")
                }
                return mock(response: body)
                        .processRequest(method: "POST", httpBody: httpBody)
            }
            return processRequest(method: "POST", httpBody: httpBody)
        } catch let error {
            decoder?.handleResponse(data: nil, error: error, urlResponse: urlResponse)
            return self
        }
    }
    public func post(json: String?) -> Self {
        guard let json = json else {
            return processRequest(method: "POST", httpBody: nil)
        }
        guard let httpBody = json.data(using: .utf8) else {
            let error = AsyncRestError.jsonEncodingError(json: json)
            decoder?.handleResponse(data: nil, error: error, urlResponse: urlResponse)
            return self
        }
        return processRequest(method: "POST", httpBody: httpBody)
    }
    public func put<Body: Encodable>(body: Body? = nil, mockResponse: Bool = false) -> Self {
        guard let body = body else {
            if mockResponse {
                fatalError("Cannot mock response, none given.")
            }
            return processRequest(method: "PUT", httpBody: nil)
        }
        do {
            let encoder = JSONEncoder()
            let httpBody = try encoder.encode(body)
            if mockResponse {
                guard let body = body as? Codable else {
                    fatalError("Cannot mock response from body")
                }
                return mock(response: body)
                        .processRequest(method: "PUT", httpBody: httpBody)
            }
            return processRequest(method: "PUT", httpBody: httpBody)
        } catch let error {
            decoder?.handleResponse(data: nil, error: error, urlResponse: urlResponse)
            return self
        }
    }
    public func put(json: String?) -> Self {
        guard let json = json else {
            return processRequest(method: "PUT", httpBody: nil)
        }
        guard let httpBody = json.data(using: .utf8) else {
            let error = AsyncRestError.jsonEncodingError(json: json)
            decoder?.handleResponse(data: nil, error: error, urlResponse: urlResponse)
            return self
        }
        return processRequest(method: "PUT", httpBody: httpBody)
    }
}

