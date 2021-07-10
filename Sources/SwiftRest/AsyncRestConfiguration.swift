//
//  File.swift
//  
//
//  Created by Douglas Pedley on 7/10/21.
//

import Foundation

/// AsyncRestConfiguration - This structure provides configuration details for an AsyncRestRequest. The attributes are expected to be common across all the
/// resources of the service. It does not specify the properties that are unique to a request, such as the query parameters. 
public struct AsyncRestConfiguration {
    /// baseURL - the url for the rest server being accessed. This shound not include the path or query parameters, see AsyncRestRequest for those.
    var baseURL: URL?
    /// encodePlusInParameters - To account for the difference between RFC 3986 and W3C recommendations for encoding the "+" in queryItems
    var encodePlusInParameters: Bool
    /// addJSONHeaders - when set to true, the content for the payloads being sent and received are assumed to be JSON and the proper headers are set.
    var addJSONHeaders: Bool
    public init(baseURL: URL? = nil, encodePlusInParameters: Bool = true, addJSONHeaders: Bool = true) {
        self.baseURL = baseURL
        self.encodePlusInParameters = encodePlusInParameters
        self.addJSONHeaders = addJSONHeaders
    }
}
