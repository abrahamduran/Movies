//
//  Notification+Extension.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let networkIsReachable = Notification.Name("\(Bundle.bundleId).notifications.network-reachable")
    static let networkIsUnreachable = Notification.Name("\(Bundle.bundleId).notifications.network-unreachable")
}
