//
//  Movie.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Tagged

struct Movie: Decodable {
    let id: Id
    let title: String
    let rating: Double
    let posterPath: String
    let releaseDate: Date
    var isFavorite: Bool
    var isInWatchList: Bool
    var detail: MovieDetail?
    
    typealias Id = Tagged<Movie, Int>
}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case id, title, vote_average, poster_path, results
        case release_date
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        container = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
        id = try container.decode(Movie.Id.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        rating = try container.decode(Double.self, forKey: .vote_average)
        posterPath = try container.decode(String.self, forKey: .poster_path)
        releaseDate = Date(with: try container.decode(String.self, forKey: .release_date))!
        isFavorite = false
        isInWatchList = false
    }
}
