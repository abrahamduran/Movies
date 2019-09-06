//
//  APIService.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class APIService: MoviesDataSource {
    private let api: APIClient
    
    init(apiClient: APIClient) { api = apiClient }
    
    func discoverMovies(by year: Year, with sort: SortOption, completion: @escaping (ReadMoviesOperation) -> Void) {
        let request = MovieRequest.discover(by: year, with: sort)
        completionHandler(request: request, completion: completion)
    }
    
    func getDetail(for movie: Movie, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let request = MovieRequest.detail(for: movie.id)
        api.execute(request) { result in
            switch result {
            case .success(let data):
                do {
                    completion(.success(try JSONDecoder().decode(MovieDetail.self, from: data)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchMovies(with query: String, completion: @escaping (ReadMoviesOperation) -> Void) {
        let request = MovieRequest.search(query)
        completionHandler(request: request, completion: completion)
    }
    
    func getFavoriteMovies(completion: @escaping (ReadMoviesOperation) -> Void) {
        completion(.failure(ApplicationError.notImplemented))
    }
    
    func getWatchList(completion: @escaping (ReadMoviesOperation) -> Void) {
        completion(.failure(ApplicationError.notImplemented))
    }
    
    private func completionHandler(request: RequestConvertible, completion: @escaping (ReadMoviesOperation) -> Void) {
        api.execute(request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(APIService.Response.self, from: data)
                    completion(.success(response.results))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension APIService {
    struct Response: Decodable {
        let results: [Movie]
    }
}
