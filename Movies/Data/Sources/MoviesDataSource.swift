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
}
