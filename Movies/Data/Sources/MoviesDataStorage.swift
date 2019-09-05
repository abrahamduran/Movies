//
//  MoviesDataStorage.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

protocol MoviesDataStorage {
    typealias SaveOperationResult = Result<(), Error>
    func save(_ movie: Movie) -> SaveOperationResult
    func save(_ movieDetail: MovieDetail) -> SaveOperationResult
}
