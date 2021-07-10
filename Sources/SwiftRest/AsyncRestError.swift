//
//  File.swift
//  
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import Combine

/// AsyncRestError - The error returned when binding to a result and a failure happens.
public enum AsyncRestError: Error {
    case httpNoResponse
    case httpNoResponseError(error: Error)
    case decodingError(error: Error)
    case jsonEncodingError(json: String)
}
