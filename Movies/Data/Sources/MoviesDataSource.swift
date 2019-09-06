//
//  MoviesDataSource.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

protocol MoviesDataSource {
    typealias ReadMoviesOperation = Result<[Movie], Error>
    func discoverMovies(by year: Year, with sort: SortOption, completion: @escaping (ReadMoviesOperation) -> Void)
    func getDetail(for movie: Movie, completion: @escaping (Result<MovieDetail, Error>) -> Void)
    func searchMovies(with query: String, in context: SearchContext, completion: @escaping (ReadMoviesOperation) -> Void)
    func getFavoriteMovies(completion: @escaping (ReadMoviesOperation) -> Void)
    func getWatchList(completion: @escaping (ReadMoviesOperation) -> Void)
    
    func discoverMovies(by year: Year, with sort: SortOption) -> ReadMoviesOperation
    func getDetail(for movie: Movie) -> Result<MovieDetail, Error>
    func searchMovies(with query: String, in context: SearchContext) -> ReadMoviesOperation
    func getFavoriteMovies() -> ReadMoviesOperation
    func getWatchList() -> ReadMoviesOperation
}

extension MoviesDataSource {
    func discoverMovies(by year: Year, with sort: SortOption) -> ReadMoviesOperation {
        var readResult: ReadMoviesOperation!
        let group = DispatchGroup()
        group.enter()
        discoverMovies(by: year, with: sort) { result in
            readResult = result
            group.leave()
        }
        group.wait()
        return readResult
    }
    
    func getDetail(for movie: Movie) -> Result<MovieDetail, Error> {
        var readResult: Result<MovieDetail, Error>!
        let group = DispatchGroup()
        group.enter()
        getDetail(for: movie) { result in
            readResult = result
            group.leave()
        }
        group.wait()
        return readResult
    }
    
    func searchMovies(with query: String, in context: SearchContext) -> ReadMoviesOperation {var readResult: ReadMoviesOperation!
        let group = DispatchGroup()
        group.enter()
        searchMovies(with: query, in: context) { result in
            readResult = result
            group.leave()
        }
        group.wait()
        return readResult
        
    }
    
    func getFavoriteMovies() -> ReadMoviesOperation {
        var readResult: ReadMoviesOperation!
        let group = DispatchGroup()
        group.enter()
        getFavoriteMovies { result in
            readResult = result
            group.leave()
        }
        group.wait()
        return readResult
    }
    
    func getWatchList() -> ReadMoviesOperation {
        var readResult: ReadMoviesOperation!
        let group = DispatchGroup()
        group.enter()
        getWatchList { result in
            readResult = result
            group.leave()
        }
        group.wait()
        return readResult
    }
}
