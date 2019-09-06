//
//  NetworkParameters.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

struct NetworkParameters {
    let apiUrl: URL
    let hostName: String
    let timeoutForRequest: Double
    let authKeys: [String: String]
    
    static func appConfiguration() throws -> NetworkParameters {
        let info = Bundle.main.object(forInfoDictionaryKey: "NetworkParameters") as? [String: Any]
        guard let host = info?["HostName"] as? String,
            let urlString = info?["URL"] as? String,
            let timeout = info?["TimeoutForRequest"] as? Double,
            let authKeys = info?["AuthKeys"] as? [String: String]
            else { fatalError("Missing Network Parameters.") }
        
        guard let apiUrl = URL(string: urlString)
        else { fatalError("Invalid API URL.") }
        
        return self.init(apiUrl: apiUrl, hostName: host, timeoutForRequest: timeout, authKeys: authKeys)
    }
}
