//
//  MovieWrapper.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class MovieWrapper: NSObject {
    var movie: Movie
    
    init(with movie: Movie) {
        self.movie = movie
    }
}
