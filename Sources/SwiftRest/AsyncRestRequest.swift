//
//  AsyncRestRequest.swift
//  
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import Combine

public struct AsyncRestConfiguration {
    var baseURL: URL?
    var encodePlusInParameters = true
    var mockResponse: Decodable?
}

public protocol AsyncRestDecoding {
    func handleResponse(data: Data?, error: Error?)
    func mock(response: Decodable)
    func mock(error: AsyncRestError)
}

public class AsyncRestRequest {
    var configuration: AsyncRestConfiguration
    private var dataPublisher: AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>?
    private var cancellables = Set<AnyCancellable>()
    private var decoder: AsyncRestDecoding?
    private var resource: String?
    private var queryParameters: [String: Codable] = [:]
    private var resourceURL: URL {
        guard let baseURL = configuration.baseURL,
              var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
                  fatalError("Cannot build a resource URL: \(configuration.baseURL?.absoluteString ?? "no baseURL given")")
        }
        if let resource = resource {
            urlComponents.path = urlComponents.path + "/\(resource)"
        }
        if !queryParameters.isEmpty {
            urlComponents.queryItems = queryParameters.map {
                URLQueryItem(name: $0, value: "\($1)")
            }
            if configuration.encodePlusInParameters {
                urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            }
        }
        guard let url = urlComponents.url else {
            fatalError("Cannot build a URL from the supplied components \(urlComponents)")
        }
        print("ResourceURL: \(url)")
        return url
    }
    private func processMockResponse() -> Self {
        // Here we send back the prepared mock reponse
        guard let mockResponse = configuration.mockResponse else {
            fatalError("processMockResponse: mock response not available.")
        }
        DispatchQueue.global().async { // TODO: create a named queue for mocks?
            // Process on the global thread to allow this fucntion to continue execution
            DispatchQueue.main.async {
                // Return the mock on the main thread
                self.decoder?.mock(response: mockResponse)
            }
        }
        return self
    }
    public func get() -> Self {
        guard configuration.mockResponse == nil else {
            return processMockResponse()
        }
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "GET"
        dataPublisher = urlSession.dataTaskPublisher(for: request).eraseToAnyPublisher()
        dataPublisher?.receive(on: DispatchQueue.main).sink(receiveCompletion: { failure in
//            print("Failure \(failure)")
            // TODO: parse failures for URLError
        }, receiveValue: { [weak self] result in
            guard let decoder = self?.decoder else { return }
            decoder.handleResponse(data: result.data, error: nil)
        }).store(in: &cancellables)
        return self
    }
    public func resource(_ resource: String) -> Self {
        self.resource = resource
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
    public func bind<Response: Decodable>(result: Binding<AsyncResult<Response>?>) -> Self {
        decoder = AsyncResultDecoder(boundResult: result)
        return self
    }
    public func bind<Response: Decodable>(success: Binding<Response?>) -> Self {
        decoder = AsyncSuccessDecoder(boundResponse: success)
        return self
    }
    public func with(baseURL: URL) -> Self {
        configuration.baseURL = baseURL
        return self
    }
    public func mock(response: Decodable) -> Self {
        configuration.mockResponse = response
        return self
    }
    public init(baseURL: URL? = nil) {
        self.configuration = AsyncRestConfiguration(baseURL: baseURL)
    }
}
