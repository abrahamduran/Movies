//
//  MovieDetailWrapper.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class MovieDetailWrapper: NSObject {
    var detail: MovieDetail
    
    init(with detail: MovieDetail) {
        self.detail = detail
    }
}
