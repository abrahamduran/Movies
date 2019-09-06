//
//  SortOption.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/6/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

enum SortOption: String {
    case popularity = "popularity.desc"
    case releaseDate = "release_date.desc"
    case rating = "vote_average.desc"
    case title = "original_title.asc"
    
    var humanized: String {
        switch self {
        case .title:        return "Title"
        case .rating:       return "Rating"
        case .popularity:   return "Popularity"
        case .releaseDate:  return "Release Date"
        }
    }
    
    static var allOptions: [SortOption] {
        return [ .title, .rating, .popularity, .releaseDate]
    }
}
