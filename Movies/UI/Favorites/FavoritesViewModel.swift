//
//  FavoritesViewModel.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/5/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol FavoritesViewModelOutput: MovieListViewModelOutput {
    var favoriteRemoved: Driver<Int> { get }
}
protocol FavoritesViewModelType: MovieListViewModelType { }

class FavoritesViewModel: DiscoverViewModel, FavoritesViewModelType, FavoritesViewModelOutput {
    override var searchContext: SearchContext { return .favorites }
    let favoriteRemoved: Driver<Int>
    
    private let favoriteRemovedProperty: BehaviorSubject<Int>
    
    override init(moviesService: MoviesServiceType) {
        favoriteRemovedProperty = BehaviorSubject<Int>(value: -1)
        favoriteRemoved = favoriteRemovedProperty
            .asDriver(onErrorJustReturn: -1)
            .filter { $0 > 0 }
        super.init(moviesService: moviesService)
    }
    
    override func loadList() {
        moviesService.getFavoriteMovies { result in
            switch result {
            case .success(let data): self.moviesProperty.onNext(data)
            case .failure(let error): self.errorProperty.onNext(error)
            }
        }
    }
    
    override func set(_ movie: Movie, isFavorite: Bool) {
        guard var movies = try? moviesProperty.value(),
            let index = movies.firstIndex(where: { $0.id == movie.id })
            else { return }
        
        var _movie = movies[index]
        _movie.isFavorite = isFavorite
        _ = moviesService.save(_movie)
        
        movies.remove(at: index)
//        favoriteRemovedProperty.onNext(index)
        moviesProperty.onNext(movies)
    }
}
