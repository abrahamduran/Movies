//
//  Errors.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

enum ApplicationError: LocalizedError {
    case notImplemented, dateParsing(date: String)
    case objectNotFound, rxSwift
    
    
    var localizedDescription: String {
        switch self {
        case .notImplemented:
            return "The invoked action is not implemented as of now."
        case .dateParsing(let date):
            return "The date \(date) could not be parsed. Either the date has an invalid format or the formatter was changed"
        case .objectNotFound:
            return "The specified query produced no results."
        case .rxSwift:
            return "RxSwift has produced an error."
        }
    }
    
    var errorDescription: String? { return localizedDescription }
}
