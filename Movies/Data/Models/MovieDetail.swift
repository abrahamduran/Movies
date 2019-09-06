//
//  MovieDetail.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RealmSwift

struct MovieDetail: Decodable {
    let id: Movie.Id
    let overview: String
    let budget: Int
    let revenue: Int
    let runtime: Minutes?
    let genres: [String]
    let productionCompanies: [String]
}

extension MovieDetail {
    enum CodingKeys: String, CodingKey {
        case id, overview, budget, revenue, runtime
        case genres, production_companies, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Movie.Id.self, forKey: .id)
        overview = try container.decode(String.self, forKey: .overview)
        budget = try container.decode(Int.self, forKey: .budget)
        revenue = try container.decode(Int.self, forKey: .revenue)
        runtime = try container.decode(Minutes?.self, forKey: .runtime)
        genres = try container.decode([Genre].self, forKey: .genres).compactMap { $0.name }
        productionCompanies = try container.decode([ProductionCompany].self, forKey: .production_companies).compactMap { $0.name }
    }
}

private typealias Genre = IdAndName
private typealias ProductionCompany = IdAndName
private struct IdAndName: Decodable {
    let id: Int
    let name: String
}

