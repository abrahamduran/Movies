//
//  MovieRequest.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Alamofire

enum MovieRequest: RequestConvertible {
    case discover(by: Year, with: SortOption)
    case detail(for: Movie.Id)
    case search(String)
    
    var path: String {
        switch self {
        case .discover:         return "/discover/movie"
        case .detail(let id):   return "/movie/\(id)"
        case .search:           return "/search/movie"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        switch self {
        case let .discover(year, sort):   return [ "year": year, "sort_by": sort.rawValue ]
        case .search(let query):    return [ "query": query ]
        default:                    return [:]
        }
    }
}
