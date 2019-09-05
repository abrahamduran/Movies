//
//  RequestAdapter.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Alamofire

class RequesAdapter: RequestAdapter {
    let authentication: (name: String, value: String)
    
    init(authKeyName: String, authKeyValue: String) {
        authentication = (name: authKeyName, value: authKeyValue)
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        let parameters = [ authentication.name : authentication.value ]
        return try URLEncoding.queryString.encode(urlRequest, with: parameters)
    }
}
