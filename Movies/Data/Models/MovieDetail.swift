//
//  MovieDetail.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

struct MovieDetail: Decodable {
    let id: Movie.Id
    let overview: String
    let budget: Int
    let revenue: Int
    let runtime: Minutes
    let genres: [String]
    let releaseDate: Date
    let productionCompanies: [String]
}

extension MovieDetail {
    enum CodingKeys: String, CodingKey {
        case id, overview, budget, revenue, runtime
        case release_date, genres, production_companies
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Movie.Id.self, forKey: .id)
        overview = try container.decode(String.self, forKey: .overview)
        budget = try container.decode(Int.self, forKey: .budget)
        revenue = try container.decode(Int.self, forKey: .revenue)
        runtime = try container.decode(Minutes.self, forKey: .runtime)
        releaseDate = Date(with: try container.decode(String.self, forKey: .release_date))!
        
        var _genres = [String]()
        let genresContainer = try container.nestedUnkeyedContainer(forKey: .genres)
        while !genresContainer.isAtEnd {
            let genre = try container.decode(String.self, forKey: .name)
            _genres.append(genre)
        }
        genres = _genres
        
        var _prodCompanies = [String]()
        let companiesContainer = try container.nestedUnkeyedContainer(forKey: .production_companies)
        while !companiesContainer.isAtEnd {
            let genre = try container.decode(String.self, forKey: .name)
            _prodCompanies.append(genre)
        }
        productionCompanies = _prodCompanies
    }
}
