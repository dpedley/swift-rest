//
//  AsyncResultDecoder.swift
//  
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import Combine

public typealias AsyncResult<Response: Decodable> = Result<Response, AsyncRestError>

public class AsyncResultDecoder<Response: Decodable>: AsyncRestDecoding {
    @Binding private var boundResult: AsyncResult<Response>?
    init(boundResult: Binding<AsyncResult<Response>?>) {
        self._boundResult = boundResult
    }
    public func mock(response: Decodable) {
        guard let response = response as? Response else {
            fatalError("Mock response not given as the expected type.")
        }
        boundResult = .success(response)
    }
    public func mock(error: AsyncRestError) {
        boundResult = .failure(error)
    }
    public func handleResponse(data: Data?, error: Error?, urlResponse: URLResponse?) {
        print("Parsing response")
        // Check for an error before decoding the data
        if let error = error {
            print("Parsing error: \(error)")
            guard let error = error as? AsyncRestError else {
                boundResult = .failure(AsyncRestError.httpNoResponseError(error: error))
                return
            }
            boundResult = .failure(error)
            return
        }
        guard let data = data else {
            print("No Data")
            boundResult = .failure(AsyncRestError.httpNoResponse)
            return
        }
        do {
            print("Parsing Data")
            let jsonDecoder = JSONDecoder()
            print("\nResponse:\n\(String(data: data, encoding: .utf8) ?? "No data")\n")
            let decodedResponse = try jsonDecoder.decode(Response.self, from: data)
            boundResult = .success(decodedResponse)
        } catch let decodingError {
            print("Decoding error: \(decodingError)")
            boundResult = .failure(AsyncRestError.decodingError(error: decodingError))
        }
    }
}

