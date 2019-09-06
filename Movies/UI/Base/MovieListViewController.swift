//
//  MovieListViewController.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/5/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewController: UICollectionViewController {
    var viewModel: MovieListViewModelType!
    var searchController: UISearchController!
    
    internal let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if [.available, .unknown].contains(traitCollection.forceTouchCapability) {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        // Register cell classes
        let cell = UINib(nibName: String(describing: MovieViewCell.self), bundle: nil)
        collectionView!.register(cell, forCellWithReuseIdentifier: MovieViewCell.identifier)
        (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = 1
        (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = 2
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        viewModel.output.movies.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: MovieViewCell.identifier, cellType: MovieViewCell.self)) { row, data, cell in
            cell.configure(data)
            cell.viewModel = self.viewModel
        }.disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        let navItem = tabBarController?.navigationItem ?? navigationItem
        navItem.searchController = searchController
        navItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.loadList()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "showMovieDetail", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? MovieDetailViewController else { return }
        guard let cell = sender as? MovieViewCell else { return }
        
        vc.viewModel.input.movie.onNext(cell.movie)
        vc.lowResolutionImage = cell.posterImageView.image
    }
}

// MARK: - UICollectionViewFlowLayout delegate
extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let width = (collectionView.frame.size.width - layout.minimumInteritemSpacing * GRID_COLUMNS - 1) / GRID_COLUMNS
        return CGSize(width: width, height: width * POSTER_ASPECT_RATIO)
    }
}

// MARK: - UIViewControllerPreviewing delegate
extension MovieListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard collectionView.numberOfItems(inSection: 0) > 0 else { return nil }
        
        let point = collectionView.convert(location, from: view)
        guard let indexPath = collectionView.indexPathForItem(at: point),
            let origin = collectionView.layoutAttributesForItem(at: indexPath)?.frame
            else { return nil }
        let sourceRect = view.convert(origin, from: collectionView)
        previewingContext.sourceRect = sourceRect
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetail")
        vc?.preferredContentSize = .zero
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: nil)
    }
}

// MARK: - UISearchBar delegate
extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.input.queryText.onNext(query)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.loadList()
    }
}

// MARK: - UISearchResultsUpdating delegate
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        // Update the filtered array based on the search text.
        viewModel.input.queryText.onNext(query)
    }
}
