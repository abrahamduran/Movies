//
//  RequestConvertible.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    
    func asURLRequest(baseUrl: URL) throws -> URLRequest
}

extension RequestConvertible {
    func asURLRequest(baseUrl: URL) throws -> URLRequest {
        let request = try URLRequest(url: baseUrl.appendingPathComponent(path), method: method)
        guard !parameters.isEmpty else { return request }
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
