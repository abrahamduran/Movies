//
//  MovieListViewModelType.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/5/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MovieListViewModelInput {
    var queryText: BehaviorSubject<String?> { get }
    func loadList()
    func set(_ movie: Movie, isFavorite: Bool)
    func set(_ movie: Movie, isInWatchList: Bool)
}

protocol MovieListViewModelOutput {
    var movies: Driver<[Movie]> { get }
    var error: Driver<Error> { get }
}

protocol MovieListViewModelType: class {
    var input: MovieListViewModelInput { get }
    var output: MovieListViewModelOutput { get }
}

class MovieListViewModel: MovieListViewModelType, MovieListViewModelInput, MovieListViewModelOutput {
    var input: MovieListViewModelInput { return self }
    var output: MovieListViewModelOutput { return self }
    
    let queryText: BehaviorSubject<String?>
    let movies: Driver<[Movie]>
    let error: Driver<Error>
    
    var searchContext: SearchContext { return .discover }
    internal let moviesProperty: BehaviorSubject<[Movie]>
    internal let errorProperty: BehaviorSubject<Error>
    internal let moviesService: MoviesServiceType
    private let disposeBag = DisposeBag()
    init(moviesService: MoviesServiceType) {
        self.moviesService = moviesService
        queryText = BehaviorSubject<String?>(value: nil)
        moviesProperty = BehaviorSubject<[Movie]>(value: [])
        errorProperty =  BehaviorSubject<Error>(value: ApplicationError.rxSwift)
        
        movies = moviesProperty.asDriver(onErrorJustReturn: [])
        error = errorProperty.asDriver(onErrorJustReturn: ApplicationError.rxSwift)
        
        queryText.debounce(.seconds(2), scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] query in
            guard let query = query else { self.loadList() ; return }
            guard !query.isEmpty else { return }
            self.searchInContext(query: query)
        }).disposed(by: disposeBag)
    }
    
    func loadList() {
        fatalError("Not implemented. This function must be overridden.")
    }
    
    func searchInContext(query: String) {
        moviesService.searchMovies(with: query, in: searchContext) { result in
            switch result {
            case .success(let movies):
                self.moviesProperty.onNext(movies)
            case .failure(let error): self.errorProperty.onNext(error)
            }
        }
    }
    
    func set(_ movie: Movie, isFavorite: Bool) {
        guard var movies = try? moviesProperty.value(),
            let index = movies.firstIndex(where: { $0.id == movie.id })
            else { return }
        
        var _movie = movies[index]
        _movie.isFavorite = isFavorite
        _ = moviesService.save(_movie)
        
        movies[index] = _movie
        moviesProperty.onNext(movies)
    }
    
    func set(_ movie: Movie, isInWatchList: Bool) {
        guard var movies = try? moviesProperty.value(),
            let index = movies.firstIndex(where: { $0.id == movie.id })
            else { return }
        
        var _movie = movies[index]
        _movie.isInWatchList = isInWatchList
        _ = moviesService.save(_movie)
        
        movies[index] = _movie
        moviesProperty.onNext(movies)
    }
}
