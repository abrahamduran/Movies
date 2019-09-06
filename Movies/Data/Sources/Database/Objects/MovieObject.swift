//
//  MovieObject.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var rating = 0.0
    @objc dynamic var posterPath: String? = nil
    @objc dynamic var isFavorite = false
    @objc dynamic var isInWatchList = false
    @objc dynamic var detail: MovieDetailObject?
    @objc dynamic var releaseDate: Date? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Movie: Persistable {
    init(with object: MovieObject) {
        id = Movie.Id(rawValue: object.id)
        title = object.title
        rating = object.rating
        posterPath = object.posterPath
        isFavorite = object.isFavorite
        releaseDate = object.releaseDate
        isInWatchList = object.isInWatchList
        if let objDetail = object.detail {
            detail = MovieDetail(with: objDetail)
        } else { detail = nil }
    }
    
    func realmObject() -> MovieObject {
        let object = MovieObject()
        object.id = id.rawValue
        object.title = title
        object.rating = rating
        object.posterPath = posterPath
        object.isFavorite = isFavorite
        object.releaseDate = releaseDate
        object.isInWatchList = isInWatchList
        object.detail = detail?.realmObject()
        return object
    }
}
