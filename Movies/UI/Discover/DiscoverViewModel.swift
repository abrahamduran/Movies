//
//  DiscoverViewModel.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/5/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol DiscoverViewModelInput: MovieListViewModelInput {
    var sortOption: SortOption { get set }
    var year: Year { get }
}

protocol DiscoverViewModelType: MovieListViewModelType { }

class DiscoverViewModel: MovieListViewModel, DiscoverViewModelType, DiscoverViewModelInput {
    override var searchContext: SearchContext { return .discover }
    
    var year: Year
    var sortOption: SortOption {
        didSet {
            guard oldValue != sortOption else { return }
            loadList()
        }
    }
    
    override init(moviesService: MoviesServiceType) {
        year = Date().year
        sortOption = .popularity
        super.init(moviesService: moviesService)
    }
    
    override func loadList() {
        moviesService.discoverMovies(by: year, with: sortOption, completion: { result in
            switch result {
            case .success(let data): self.moviesProperty.onNext(data)
            case .failure(let error): self.errorProperty.onNext(error)
            }
        })
    }
}
