//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/6/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MovieDetailViewModelInput {
    var movie: BehaviorSubject<Movie?> { get }
    func set(isFavorite: Bool)
    func set(isInWatchList: Bool)
}

protocol MovieDetailViewModelOutput {
    var movieInfo: Driver<Movie?> { get }
    var movieDetail: Driver<MovieDetail?> { get }
    var error: Driver<Error> { get }
}

protocol MovieDetailViewModelType: class {
    var input: MovieDetailViewModelInput { get }
    var output: MovieDetailViewModelOutput { get }
}

class MovieDetailViewModel: MovieDetailViewModelType, MovieDetailViewModelInput, MovieDetailViewModelOutput {
    var input: MovieDetailViewModelInput { return self }
    var output: MovieDetailViewModelOutput { return self }
    
    let movie: BehaviorSubject<Movie?>
    let movieInfo: Driver<Movie?>
    let movieDetail: Driver<MovieDetail?>
    let error: Driver<Error>
    
    private let detailProperty: BehaviorSubject<MovieDetail?>
    private let errorProperty: BehaviorSubject<Error>
    private let moviesService: MoviesServiceType
    private let disposeBag = DisposeBag()
    
    init(moviesService: MoviesServiceType) {
        self.moviesService = moviesService
        movie = BehaviorSubject<Movie?>(value: nil)
        movieInfo = movie.asDriver(onErrorJustReturn: nil)
        detailProperty = BehaviorSubject<MovieDetail?>(value: nil)
        movieDetail = detailProperty.asDriver(onErrorJustReturn: nil)
        errorProperty =  BehaviorSubject<Error>(value: ApplicationError.rxSwift)
        error = errorProperty.asDriver(onErrorJustReturn: ApplicationError.rxSwift)
        
        movie.compactMap { $0 }.bind(onNext: { [weak self] movie in
            self?.moviesService.getDetail(for: movie) { result in
                switch result {
                case .success(let detail):
                    self?.detailProperty.onNext(detail)
                case .failure(let error):
                    self?.errorProperty.onNext(error)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func set(isFavorite: Bool) {
        guard var _movie = try? movie.value() else { return }
        _movie.isFavorite = isFavorite
        _ = moviesService.save(_movie)
    }
    
    func set(isInWatchList: Bool) {
        guard var _movie = try? movie.value() else { return }
        _movie.isInWatchList = isInWatchList
        _ = moviesService.save(_movie)
    }
}
