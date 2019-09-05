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
    
    func discoverMovies(by year: Year, completion: @escaping (ReadMoviesOperation) -> Void) {
        guard let beginDate = Date(with: "\(year)-01-01") else {
            completion(.failure(ApplicationError.dateParsing(date: "\(year)-01-01")))
            return
        }
        guard let endDate = Date(with: "\(year)-12-31") else {
            completion(.failure(ApplicationError.dateParsing(date: "\(year)-12-31")))
            return
        }
        
        let movies = getMoviesInCache()
        let filterdMovies = movies.filter { $0.releaseDate >= beginDate && $0.releaseDate <= endDate }
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
    
    func searchMovies(with query: String, completion: @escaping (ReadMoviesOperation) -> Void) {
        let movies = getMoviesInCache()
        let filterdMovies = movies.filter { $0.title.lowercased().contains(query.lowercased()) }
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
