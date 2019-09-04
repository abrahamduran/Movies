//
//  APIClientError.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

enum APIClientError: LocalizedError {
    case noInternetConnection, unauthorized, api(message: String), other
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection:
            return "No internet connection"
        case .unauthorized:
            return "User might not be logged, or does not have enough privileges for the action."
        case .api(let message):
            return "\(message)"
        case .other:
            return "Something went wrong on our side."
        }
    }
    
    var errorDescription: String? { return localizedDescription }
}
