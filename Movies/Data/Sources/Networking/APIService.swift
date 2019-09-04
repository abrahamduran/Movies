//
//  APIService.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

final class APIService: MoviesDataSource {
    private let api: APIClient
    
    init(apiClient: APIClient) { api = apiClient }
    
    func discoverMovies(by year: Year, completion: @escaping ReadMoviesOperation) {
        let request = MovieRequest.discover(by: year)
        completionHandler(request: request, completion: completion)
    }
    
    func getDetail(for movie: Movie, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let request = MovieRequest.detail(for: movie.id)
        completionHandler(request: request, completion: completion)
    }
    
    func searchMovies(with query: String, completion: @escaping ReadMoviesOperation) {
        let request = MovieRequest.search(query)
        completionHandler(request: request, completion: completion)
    }
    
    func getFavoriteMovies(completion: @escaping ReadMoviesOperation) {
        completion(.failure(ApplicationError.notImplemented))
    }
    
    func getWatchList(completion: @escaping ReadMoviesOperation) {
        completion(.failure(ApplicationError.notImplemented))
    }
    
    private func completionHandler<T: Decodable>(request: RequestConvertible, completion: @escaping (Result<T, Error>) -> Void) {
        api.execute(request) { result in
            switch result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
