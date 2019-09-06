//
//  ReachabilityManager.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Alamofire

final class ReachabilityManager {
    public static let shared = ReachabilityManager()
    private let manager: NetworkReachabilityManager?
    private var isListening = false
    
    private init() {
        manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            var name: Notification.Name = .networkIsReachable
            if [.unknown, .notReachable].contains(status) {
                name = .networkIsUnreachable
            }
            
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
    
    var isReachable: Bool {
        return manager?.isReachable ?? false
    }
    
    var isReachableOverWifi: Bool {
        return manager?.isReachableOnEthernetOrWiFi ?? false
    }
    
    func start() {
        guard !isListening else { return }
        isListening = manager?.startListening() ?? false
    }
    
    func stop() {
        manager?.stopListening()
        isListening = false
    }
}
