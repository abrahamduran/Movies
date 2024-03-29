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
    func discoverMovies(by year: Year, with sort: SortOption, completion: @escaping (ReadMoviesOperation) -> Void) {
        let realm: Realm!
        do {
            realm = try Realm()
        } catch {
            completion(.failure(error)) ; return
        }
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
        let realm: Realm!
        do {
            realm = try Realm()
        } catch {
            completion(.failure(error)) ; return
        }
        let result = realm.objects(MovieDetailObject.self).filter("id == %@", movie.id.rawValue).first
        if let result = result {
            completion(.success(MovieDetail(with: result)))
        } else {
            completion(.failure(ApplicationError.objectNotFound))
        }
    }
    
    func searchMovies(with query: String, in context: SearchContext, completion: @escaping (ReadMoviesOperation) -> Void) {
        let realm: Realm!
        do {
            realm = try Realm()
        } catch {
            completion(.failure(error)) ; return
        }
        let contextFilter = { () -> String in
            switch context {
            case .favorites: return "isFavorite == true"
            case .watchList: return "isInWatchList == true"
            default: return ""
            }
        }()
        let predicate = NSPredicate(format: "title CONTAINS[c] %@", query)
        let results = realm.objects(MovieObject.self).filter(predicate).filter(contextFilter)
        completion(.success(results.map { Movie(with: $0) }))
    }
    
    func getFavoriteMovies(completion: @escaping (ReadMoviesOperation) -> Void) {
        let realm: Realm!
        do {
            realm = try Realm()
        } catch {
            completion(.failure(error)) ; return
        }
        let results = realm.objects(MovieObject.self).filter("isFavorite == true")
        completion(.success(results.map { Movie(with: $0) }))
    }
    
    func getWatchList(completion: @escaping (ReadMoviesOperation) -> Void) {
        let realm: Realm!
        do {
            realm = try Realm()
        } catch {
            completion(.failure(error)) ; return
        }
        let results = realm.objects(MovieObject.self).filter("isInWatchList == true")
        completion(.success(results.map { Movie(with: $0) }))
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        guard let realm = try? Realm() else { return false }
        let result = realm.objects(MovieObject.self).filter("id == %@", movie.id.rawValue).first
        return result?.isFavorite ?? false
    }
    
    func isInWatchList(_ movie: Movie) -> Bool {
        guard let realm = try? Realm() else { return false }
        let result = realm.objects(MovieObject.self).filter("id == %@", movie.id.rawValue).first
        return result?.isInWatchList ?? false
    }
    
    @discardableResult
    func save(_ movie: Movie) -> SaveOperationResult {
        let object = movie.realmObject()
        return save(object)
    }
    
    @discardableResult
    func save(_ movieDetail: MovieDetail) -> SaveOperationResult {
        let object = movieDetail.realmObject()
        return save(object)
    }
    
    private func save(_ object: Object) -> SaveOperationResult {
        let realm: Realm!
        do {
            realm = try Realm()
        } catch {
            return .failure(error)
        }
        return Result {
            try realm.write {
                realm.add(object, update: .modified)
            }
        }
    }
}
