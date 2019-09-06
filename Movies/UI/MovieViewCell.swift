//
//  MovieViewCell.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit
import Cosmos
import RxSwift
import RxCocoa
import FaveButton

class MovieViewCell: UICollectionViewCell {
    static let identifier = "movie-cell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: FaveButton!
    @IBOutlet weak var ratingView: CosmosView!
    
    weak var viewModel: MovieListViewModelType?
    var movie: Movie!
    
    override var canBecomeFirstResponder: Bool { return true }
    
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.image = nil
        posterImageView.rx.observe(UIImage?.self, "image")
        .map { image in return image == nil }
        .bind(to: activityIndicator.rx.isAnimating)
        .disposed(by: disposeBag)
    }

    func configure(_ movie: Movie) {
        self.movie = movie
        titleLabel.text = movie.title
        ratingView.rating = movie.rating
        if let url = movie.lowResolutionPoster {
            posterImageView.contentMode = .scaleAspectFit
            posterImageView.setImage(with: url)
        } else {
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.image = UIImage(named: "no-poster")
        }
        favoriteButton.setSelected(selected: movie.isFavorite, animated: false)
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
        addGestureRecognizer(longPressGR)
        
    }
    
    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began,
            let senderView = sender.view,
            let superView = sender.view?.superview
            else { return }
        
        senderView.becomeFirstResponder()
        let title = movie.isInWatchList ? "Remove from Watch List" : "Add to Watch List"
        let item = UIMenuItem(title: title, action: #selector(setIsInWatchList))
        UIMenuController.shared.menuItems = [item]
        
        // Tell the menu controller the first responder's frame and its super view
        UIMenuController.shared.setTargetRect(senderView.frame, in: superView)
        
        // Animate the menu onto view
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(setIsInWatchList)
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel?.input.set(self.movie, isFavorite: self.favoriteButton.isSelected)
        }
    }
    
    @objc func setIsInWatchList() {
        viewModel?.input.set(movie, isInWatchList: !movie.isInWatchList)
    }
}
