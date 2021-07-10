//
//  AsyncRestRequest+Modifiers.swift
//  
//
//  Created by Douglas Pedley on 7/10/21.
//

import SwiftUI
import Combine

extension AsyncRestRequest {
    public func bind<Response: Decodable>(result: Binding<AsyncResult<Response>?>) -> Self {
        decoder = AsyncResultDecoder(boundResult: result)
        return self
    }
    public func bind<Response: Decodable>(success: Binding<Response?>) -> Self {
        decoder = AsyncSuccessDecoder(boundResponse: success)
        return self
    }
    public func bind(statusCode: Binding<Int?>) -> Self {
        decoder = AsyncStatusCodeDecoder(boundCode: statusCode)
        return self
    }
    public func resource(_ resource: String) -> Self {
        self.resource = resource
        return self
    }
    public func addHeader(_ name: String, value: Codable) -> Self {
        requestHeaders[name] = value
        return self
    }
    public func withHeaders(_ headers: [String: Codable]) -> Self {
        requestHeaders = headers
        return self
    }
    public func addQueryParameter(_ name: String, value: Codable) -> Self {
        queryParameters[name] = value
        return self
    }
    public func withQueryParameters(_ parameters: [String: Codable]) -> Self {
        queryParameters = parameters
        return self
    }
    public func setEncodePlusInParameters(_ encodePlus: Bool) -> Self {
        configuration.encodePlusInParameters = encodePlus
        return self
    }
    public func with(baseURL: URL) -> Self {
        configuration.baseURL = baseURL
        return self
    }
    public func mock(response: Decodable) -> Self {
        mockResponse = response
        return self
    }
}
