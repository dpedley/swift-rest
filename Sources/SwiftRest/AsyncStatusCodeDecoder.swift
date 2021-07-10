//
//  AsyncStatusCodeDecoder.swift
//  
//
//  Created by Douglas Pedley on 7/10/21.
//

import SwiftUI
import Combine

public class AsyncStatusCodeDecoder: AsyncRestDecoding {
    @Binding private var boundCode: Int?
    init(boundCode: Binding<Int?>) {
        self._boundCode = boundCode
    }
    public func mock(response: Decodable) {
        guard let responseCode = response as? Int else {
            fatalError("Mock response must be an Int when mocking via statusCode.")
        }
        boundCode = responseCode
    }
    public func mock(error: AsyncRestError) {
        print("AsyncSuccessDecoder error: \(error)")
        boundCode = nil
    }
    public func handleResponse(data: Data?, error: Error?, urlResponse: URLResponse?) {
        // Check for an error before decoding the data
        guard error == nil, let urlResponse = urlResponse as? HTTPURLResponse else {
            boundCode = nil
            return
        }
        self.boundCode = urlResponse.statusCode
    }
}
