//
//  AsyncRestRequest+URLHandling.swift
//  
//
//  Created by Douglas Pedley on 7/10/21.
//

import SwiftUI
import Combine

extension AsyncRestRequest {
    func buildRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        if configuration.addJSONHeaders {
            _ = addHeader("Content-Type", value: "application/json")
            _ = addHeader("Accept", value: "application/json")
        }
        for name in requestHeaders.keys {
            guard let value = requestHeaders[name] else { continue }
            request.addValue("\(value)", forHTTPHeaderField: name)
        }
        return request
    }
    func buildResourceURL() -> URL {
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
    func processMockResponse() -> Self {
        // Here we send back the prepared mock reponse
        guard let mockResponse = mockResponse else {
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
    func processRequest(method: String, httpBody: Data?) -> Self {
        guard mockResponse == nil else {
            return processMockResponse()
        }
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        var request = buildRequest(url: buildResourceURL())
        request.httpMethod = method
        if let httpBody = httpBody {
            request.httpBody = httpBody
        }
        dataPublisher = urlSession.dataTaskPublisher(for: request).eraseToAnyPublisher()
        dataPublisher?
            .tryMap() { element -> Data in
                self.urlResponse = element.response
                return element.data
            }
            .receive(on: DispatchQueue.main).sink(receiveCompletion: { failure in
//            print("Failure \(failure)")
            // TODO: parse failures for URLError
        }, receiveValue: { [weak self] data in
            guard let self = self, let decoder = self.decoder else { return }
            decoder.handleResponse(data: data, error: nil, urlResponse: self.urlResponse)
        }).store(in: &cancellables)
        return self
    }
}
