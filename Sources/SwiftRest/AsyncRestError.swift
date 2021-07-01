//
//  File.swift
//  
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import Combine

public enum AsyncRestError: Error {
    case httpNoResponse
    case httpNoResponseError(error: Error)
    case decodingError(error: Error)
    case jsonEncodingError(json: String)
}
