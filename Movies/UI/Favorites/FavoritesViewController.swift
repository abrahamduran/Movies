//
//  FavoritesViewController.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/5/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

class FavoritesViewController: MovieListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        (viewModel.output as? FavoritesViewModelOutput)?.favoriteRemoved
//            .drive(onNext: { [weak self] index in
//                let indexpath = IndexPath(item: index, section: 0)
//                self?.collectionView.deleteItems(at: [indexpath])
//            }).disposed(by: disposeBag)
    }
}
