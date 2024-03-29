//
//  InMemoryCacheService.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class InMemoryCacheService: MoviesDataSource, MoviesDataStorage {
    private var moviesKeys: Set<NSString>
    private let moviesCache: NSCache<NSString, MovieWrapper>
    private let detailsCache: NSCache<NSString, MovieDetailWrapper>
    
    init() {
        moviesKeys = []
        moviesCache = NSCache<NSString, MovieWrapper>()
        detailsCache = NSCache<NSString, MovieDetailWrapper>()
    }
    
    func discoverMovies(by year: Year, with sort: SortOption, completion: @escaping (ReadMoviesOperation) -> Void) {
        guard let beginDate = Date(with: "\(year)-01-01") else {
            completion(.failure(ApplicationError.dateParsing(date: "\(year)-01-01")))
            return
        }
        guard let endDate = Date(with: "\(year)-12-31") else {
            completion(.failure(ApplicationError.dateParsing(date: "\(year)-12-31")))
            return
        }
        
        let movies = getMoviesInCache()
        let filterdMovies = movies.filter {
            if let date = $0.releaseDate {
                return date >= beginDate && date <= endDate
            }
            return false
        }
        completion(.success(filterdMovies))
    }
    
    func getDetail(for movie: Movie, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let key = "\(movie.id)" as NSString
        guard let result = detailsCache.object(forKey: key) else {
            completion(.failure(ApplicationError.objectNotFound))
            return
        }
        
        completion(.success(result.detail))
    }
    
    func searchMovies(with query: String, in context: SearchContext, completion: @escaping (ReadMoviesOperation) -> Void) {
        let movies = getMoviesInCache()
        var filterdMovies = { (movies) -> [Movie] in
            switch context {
            case .favorites: return movies.filter { $0.isFavorite }
            case .watchList: return movies.filter { $0.isInWatchList }
            default: return movies
            }
        }(movies)
        filterdMovies = filterdMovies.filter { $0.title.lowercased().contains(query.lowercased()) }
        completion(.success(filterdMovies))
    }
    
    func getFavoriteMovies(completion: @escaping (ReadMoviesOperation) -> Void) {
        let movies = getMoviesInCache()
        let filteredMovies = movies.filter { $0.isFavorite }
        completion(.success(filteredMovies))
    }
    
    func getWatchList(completion: @escaping (ReadMoviesOperation) -> Void) {
        let movies = getMoviesInCache()
        let filteredMovies = movies.filter { $0.isInWatchList }
        completion(.success(filteredMovies))
    }
    
    func isFavorite(_ movie: Movie) -> Bool? {
        let movies = getMoviesInCache()
        let result = movies.first { $0.id == movie.id }
        return result?.isFavorite ?? nil
    }
    
    func isInWatchList(_ movie: Movie) -> Bool? {
        let movies = getMoviesInCache()
        let result = movies.first { $0.id == movie.id }
        return result?.isInWatchList ?? nil
    }
    
    private func getMoviesInCache() -> [Movie] {
        var movies = [Movie]()
        let keys = moviesKeys
        for key in keys {
            guard let result = moviesCache.object(forKey: key) else {
                moviesKeys.remove(key) ; continue
            }
            movies.append(result.movie)
        }
        
        return movies
    }
    
    @discardableResult
    func save(_ movie: Movie) -> SaveOperationResult {
        let key = "\(movie.id)" as NSString
        moviesCache.setObject(MovieWrapper(with: movie), forKey: key)
        moviesKeys.insert(key)
        return Result { }
    }
    
    @discardableResult
    func save(_ movieDetail: MovieDetail) -> SaveOperationResult {
        let key = "\(movieDetail.id)" as NSString
        detailsCache.setObject(MovieDetailWrapper(with: movieDetail), forKey: key)
        return Result { }
    }
}
