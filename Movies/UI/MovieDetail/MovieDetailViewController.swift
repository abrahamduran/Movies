//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/6/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit
import Cosmos
import FaveButton
import RxCocoa
import RxSwift

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var favoriteButton: FaveButton!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    var lowResolutionImage: UIImage!
    var viewModel: MovieDetailViewModelType!

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        posterImageView.image = lowResolutionImage
        
        viewModel.output.movieDetail
        .asObservable().compactMap { $0 }
        .subscribe(onNext: { [weak self] detail in
            guard let self = self else { return }
            let runtime = detail.runtime ?? 0
            self.runtimeLabel.text = "Runtime: \(runtime > 0 ? "\(runtime) minutes" : "Unknown")"
            self.overviewTextView.text = detail.overview
            self.genresLabel.text = "Genres: \(detail.genres.joined(separator: ", "))"
            self.productionLabel.text = "Production Companies: \(detail.productionCompanies.joined(separator: ", "))"
            let size = self.overviewTextView.sizeThatFits(CGSize(width: self.overviewTextView.frame.width, height: .greatestFiniteMagnitude))
            self.textViewHeightConstraint.constant = size.height
        }).disposed(by: disposeBag)
        
        viewModel.output.movieInfo
        .asObservable().compactMap { $0 }
        .subscribe(onNext: { [weak self] info in
            guard let self = self else { return }
            self.titleLabel.text = info.title
            self.ratingView.rating = info.rating
            self.releaseDateLabel.text = "Release Date: \(info.releaseDate?.dated ?? "Unknown")"
            self.favoriteButton.setSelected(selected: info.isFavorite, animated: false)
            guard let url = info.highResolutionPoster else { return }
            self.posterImageView.setImage(with: url, placeholder: self.lowResolutionImage)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        viewModel.input.set(isFavorite: favoriteButton.isSelected)
    }
}
