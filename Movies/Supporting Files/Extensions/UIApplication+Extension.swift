//
//  UIApplication+Extension.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

extension UIApplication {
    static var appName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }
    
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    static var versionBuild: String {
        return "v\(appVersion) (\(appBuild))"
    }
}

extension Bundle {
    static var bundleId: String {
        return Bundle.main.bundleIdentifier ?? "com.abrahamduran.Movies"
    }
}
