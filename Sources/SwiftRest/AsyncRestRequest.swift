//
//  AsyncRestRequest.swift
//  
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import Combine

/// AsyncRestDecoding - the decoder for an `AsyncRestRequest` differ based on which type of `bind` method is used, this protocol defines
/// the common functionality that the decoder exposes for the request to use.
public protocol AsyncRestDecoding {
    func handleResponse(data: Data?, error: Error?, urlResponse: URLResponse?)
    func mock(response: Decodable)
    func mock(error: AsyncRestError)
}

/// AsyncRestRequest - the primary class that you will use in this library. It allows setting up a rest request, binding the respose, and calling the service.
public class AsyncRestRequest {
    var configuration: AsyncRestConfiguration
    var dataPublisher: AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>?
    var cancellables = Set<AnyCancellable>()
    var decoder: AsyncRestDecoding?
    var resource: String?
    var queryParameters: [String: Codable] = [:]
    var requestHeaders: [String: Codable] = [:]
    var urlResponse: URLResponse?
    var mockResponse: Decodable?
    public init(configuration: AsyncRestConfiguration = AsyncRestConfiguration()) {
        self.configuration = configuration
    }
    public convenience init(baseURL: URL) {
        self.init(configuration: AsyncRestConfiguration(baseURL: baseURL))
    }
}

