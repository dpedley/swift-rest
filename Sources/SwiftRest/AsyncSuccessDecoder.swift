//
//  AsyncSuccessDecoder.swift
//  
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import Combine

public class AsyncSuccessDecoder<Response: Decodable>: AsyncRestDecoding {
    @Binding private var boundResponse: Response?
    init(boundResponse: Binding<Response?>) {
        self._boundResponse = boundResponse
    }
    public func mock(response: Decodable) {
        guard let response = response as? Response else {
            fatalError("Mock response not given as the expected type.")
        }
        boundResponse = response
    }
    public func mock(error: AsyncRestError) {
        print("AsyncSuccessDecoder error: \(error)")
        boundResponse = nil
    }
    public func handleResponse(data: Data?, error: Error?, urlResponse: URLResponse?) {
        // Check for an error before decoding the data
        guard error == nil, let data = data else {
            boundResponse = nil
            return
        }
        do {
            let jsonDecoder = JSONDecoder()
            let decodedResponse = try jsonDecoder.decode(Response.self, from: data)
            boundResponse = decodedResponse
        } catch {
            boundResponse = nil
        }
    }
}
