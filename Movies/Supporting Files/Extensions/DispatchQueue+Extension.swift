//
//  DispatchQueue+Extension.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static let networking = DispatchQueue(label: "\(Bundle.bundleId).networking", qos: .utility, attributes: .concurrent)
}
