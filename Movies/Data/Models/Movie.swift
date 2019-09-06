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
    let posterPath: String?
    let releaseDate: Date?
    var isFavorite: Bool
    var isInWatchList: Bool
    var detail: MovieDetail?
    
    var lowResolutionPoster: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "\(LOWRES_URL)\(path)")
    }
    var highResolutionPoster: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "\(HIGHRES_URL)\(path)")
    }
    
    typealias Id = Tagged<Movie, Int>
}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case id, title, vote_average, poster_path, results
        case release_date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Movie.Id.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        rating = try container.decode(Double.self, forKey: .vote_average) * 5 / 10
        posterPath = try container.decode(String?.self, forKey: .poster_path)
        releaseDate = Date(with: try container.decode(String.self, forKey: .release_date))
        isFavorite = false
        isInWatchList = false
    }
}
