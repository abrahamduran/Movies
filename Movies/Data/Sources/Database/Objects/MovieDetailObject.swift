//
//  MovieDetailObject.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RealmSwift

class MovieDetailObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var overview = ""
    @objc dynamic var budget = 0
    @objc dynamic var revenue = 0
    @objc dynamic var runtime = 0
    var genres = List<String>()
    var productionCompanies = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension MovieDetail: Persistable {
    init(with object: MovieDetailObject) {
        id = Movie.Id(rawValue: object.id)
        overview = object.overview
        budget = object.budget
        revenue = object.revenue
        runtime = object.runtime
        genres = object.genres.map { return $0 }
        productionCompanies = object.productionCompanies.map { return $0 }
    }
    
    func realmObject() -> MovieDetailObject {
        let object = MovieDetailObject()
        object.id = id.rawValue
        object.overview = overview
        object.budget = budget
        object.revenue = revenue
        object.runtime = runtime
        object.genres = genres.reduce(List<String>()) { (list, genre) in
            list.append(genre)
            return list
        }
        object.productionCompanies = productionCompanies.reduce(List<String>()) { (list, company) in
            list.append(company)
            return list
        }
        return object
    }
}
