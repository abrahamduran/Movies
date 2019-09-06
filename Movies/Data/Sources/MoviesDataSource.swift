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
    #warning("TODO: add sort options & paging")
    func discoverMovies(by year: Year, completion: @escaping (ReadMoviesOperation) -> Void)
    func getDetail(for movie: Movie, completion: @escaping (Result<MovieDetail, Error>) -> Void)
    func searchMovies(with query: String, completion: @escaping (ReadMoviesOperation) -> Void)
    func getFavoriteMovies(completion: @escaping (ReadMoviesOperation) -> Void)
    func getWatchList(completion: @escaping (ReadMoviesOperation) -> Void)
    
    func discoverMovies(by year: Year) -> ReadMoviesOperation
    func getDetail(for movie: Movie) -> Result<MovieDetail, Error>
    func searchMovies(with query: String) -> ReadMoviesOperation
    func getFavoriteMovies() -> ReadMoviesOperation
    func getWatchList() -> ReadMoviesOperation
}

extension MoviesDataSource {
    func discoverMovies(by year: Year) -> ReadMoviesOperation {
        var readResult: ReadMoviesOperation!
        let group = DispatchGroup()
        group.enter()
        discoverMovies(by: year) { result in
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
    
    func searchMovies(with query: String) -> ReadMoviesOperation {var readResult: ReadMoviesOperation!
        let group = DispatchGroup()
        group.enter()
        searchMovies(with: query) { result in
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
