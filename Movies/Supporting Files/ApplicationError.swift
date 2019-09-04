//
//  Errors.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

enum ApplicationError: LocalizedError {
    case notImplemented
    
    
    var localizedDescription: String {
        switch self {
        case .notImplemented:
            return "The invoked action is not implemented as of now."
        }
    }
    
    var errorDescription: String? { return localizedDescription }
}
