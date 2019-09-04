//
//  RealmService.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmService: MoviesDataSource, MoviesDataStorage {
    private let realm: Realm
    
    init() throws {
        realm = try Realm()
    }
    
    func discoverMovies(by year: Year, completion: @escaping ReadMoviesOperation) {
        guard let beginDate = Date(with: "\(year)-01-01") else {
            completion(.failure(ApplicationError.dateParsing(date: "\(year)-01-01")))
            return
        }
        guard let endDate = Date(with: "\(year)-12-31") else {
            completion(.failure(ApplicationError.dateParsing(date: "\(year)-12-31")))
            return
        }
        let results = realm.objects(MovieObject.self).filter("releaseDate BETWEEN {%@, %@}", beginDate, endDate)
        completion(.success(results.map { Movie(with: $0) }))
    }
    
    func getDetail(for movie: Movie, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let result = realm.objects(MovieDetailObject.self).filter("id == %@", movie.id).first
        if let result = result {
            completion(.success(MovieDetail(with: result)))
        } else {
            completion(.failure(ApplicationError.objectNotFound))
        }
    }
    
    func searchMovies(with query: String, completion: @escaping ReadMoviesOperation) {
        let predicate = NSPredicate(format: "title CONTAINS[c][d] %@", query)
        let results = realm.objects(MovieObject.self).filter(predicate)
        completion(.success(results.map { Movie(with: $0) }))
    }
    
    func getFavoriteMovies(completion: @escaping ReadMoviesOperation) {
        let results = realm.objects(MovieObject.self).filter("isFavorite == true")
        completion(.success(results.map { Movie(with: $0) }))
    }
    
    func getWatchList(completion: @escaping ReadMoviesOperation) {
        let results = realm.objects(MovieObject.self).filter("isInWatchList == true")
        completion(.success(results.map { Movie(with: $0) }))
    }
    
    func save(_ movie: Movie, completion: SaveOperationResult) {
        let object = movie.realmObject()
        save(object, completion: completion)
    }
    
    func save(_ movieDetail: MovieDetail, completion: SaveOperationResult) {
        let object = movieDetail.realmObject()
        save(object, completion: completion)
    }
    
    private func save(_ object: Object, completion: SaveOperationResult) {
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}
