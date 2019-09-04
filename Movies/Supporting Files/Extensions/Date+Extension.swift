//
//  Date+Extension.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

// MARK: - DateFormatter
extension DateFormatter {
    convenience init(withDateFormat dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

// MARK: - Date
extension Date {
    private enum Formatters {
        // UI formatters
        static let date = DateFormatter(withDateFormat: "d MMM yyyy")
        
        // Internal use
        static let shortDate = DateFormatter(withDateFormat: "yyyy-MM-dd")
    }
    
    init?(with string: String) {
        if let date = Formatters.shortDate.date(from: s) {
            self = date
        } else { return nil }
    }
    
    var dated: String {
        return Formatters.date.string(from: self)
    }
}
