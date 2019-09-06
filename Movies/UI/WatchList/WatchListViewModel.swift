//
//  WatchListViewModel.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/6/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

protocol WatchListViewModelType: MovieListViewModelType { }

class WatchListViewModel: DiscoverViewModel, WatchListViewModelType {
    override var searchContext: SearchContext { return .watchList }
    
    override func loadList() {
        moviesService.getWatchList { result in
            switch result {
            case .success(let data): self.moviesProperty.onNext(data)
            case .failure(let error): self.errorProperty.onNext(error)
            }
        }
    }
    
    override func set(_ movie: Movie, isInWatchList: Bool) {
        guard var movies = try? moviesProperty.value(),
            let index = movies.firstIndex(where: { $0.id == movie.id })
            else { return }
        
        var _movie = movies[index]
        _movie.isInWatchList = isInWatchList
        _ = moviesService.save(_movie)
        
        movies.remove(at: index)
        moviesProperty.onNext(movies)
    }
}
