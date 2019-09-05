//
//  MoviesService.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class MoviesService: MoviesDataSource, MoviesDataStorage {
    private let inMemory: InMemoryCacheService
    private let database: RealmService
    private let network: APIService
    
    init(inMemory: InMemoryCacheService, database: RealmService, network: APIService) {
        self.inMemory = inMemory
        self.database = database
        self.network = network
    }
    
    func discoverMovies(by year: Year, completion: @escaping (ReadMoviesOperation) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var movies = [Movie]()
            var sourceError: Error?
            
            let group = DispatchGroup()
            group.enter()
            
            let block: (Result<[Movie], Error>) -> () = { result in
                switch result {
                case .success(let data): movies = data
                case .failure(let error): sourceError = error
                }
            }
            self.network.discoverMovies(by: year) { result in
                block(result) ; group.leave()
            }
            
            group.wait()
            
            if !movies.isEmpty {
                movies.forEach { self.save($0) }
                completion(.success(movies))
                return
            }
            
            group.enter()
            
            block(self.database.discoverMovies(by: year))
            
            if !movies.isEmpty {
                completion(.success(movies))
                return
            }
            
            block(self.inMemory.discoverMovies(by: year))
            
            if let error = sourceError, !movies.isEmpty {
                completion(.failure(error))
            } else { completion(.success(movies)) }
        }
    }
    
    func getDetail(for movie: Movie, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var result = self.inMemory.getDetail(for: movie)
        
            if case .success(let detail) = result {
                completion(.success(detail))
                return
            }
            
            result = self.database.getDetail(for: movie)
            
            if case .success(let detail) = result {
                completion(.success(detail))
                return
            }
            
            self.network.getDetail(for: movie) { result in
                switch result {
                case .success(let detail):
                    self.save(detail)
                    completion(.success(detail))
                case .failure(let error):
                    if  case .noInternetConnection? = (error as? APIClientError),
                        case .failure(let innerError) = result {
                        completion(.failure(innerError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func searchMovies(with query: String, completion: @escaping (ReadMoviesOperation) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            group.enter()
            var networkError: Error?
            self.network.searchMovies(with: query) { result in
                switch result {
                case .success(let movies):
                    movies.forEach { self.save($0) }
                    completion(.success(movies))
                case .failure(let error):
                    networkError = error
                }
                group.leave()
            }
            group.wait()
            guard let sourceError = networkError else { return }
            var result = self.inMemory.searchMovies(with: query)
            if case .success(let movies) = result {
                completion(.success(movies))
                return
            }
            
            result = self.database.searchMovies(with: query)
            
            switch result {
            case .success(let movie):
                completion(.success(movie))
            case .failure(let error):
                if  case .noInternetConnection? = (sourceError as? APIClientError) {
                    completion(.failure(error))
                } else {
                    completion(.failure(sourceError))
                }
            }
        }
    }
    
    func getFavoriteMovies(completion: @escaping (ReadMoviesOperation) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let result = self.database.getFavoriteMovies()
            switch result {
            case .success(let movies): completion(.success(movies))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getWatchList(completion: @escaping (ReadMoviesOperation) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let result = self.database.getWatchList()
            switch result {
            case .success(let movies): completion(.success(movies))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func save(_ movie: Movie) -> SaveOperationResult {
        inMemory.save(movie)
        return database.save(movie)
    }
    
    @discardableResult
    func save(_ movieDetail: MovieDetail) -> SaveOperationResult {
        inMemory.save(movieDetail)
        return database.save(movieDetail)
    }
}
