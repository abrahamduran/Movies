//
//  MoviesDataStorage.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

protocol MoviesDataStorage {
    typealias SaveOperationResult = (Result<Bool, Error>) -> Void
    func save(_ movie: Movie, completion: @escaping SaveOperationResult)
    func save(_ movieDetail: MovieDetail, completion: @escaping SaveOperationResult)
}
