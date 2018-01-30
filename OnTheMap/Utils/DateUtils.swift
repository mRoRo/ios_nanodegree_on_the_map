//
//  DateUtils.swift
//  OnTheMap
//
//  Created by Maro on 29/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    struct DateFormatterConstants {
        static let DateFormatString = "yyyy-MM-dd'T'HH:mm:ss.SZ"
    }
    
    func datefromUdacityApiString (_ dateString: String) -> Date? {
        // Udacity dates look like: "2015-05-10T16:48:30.760460Z"
        self.dateFormat = DateFormatterConstants.DateFormatString
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.date(from: dateString)
    }
}

extension String {
    func isDateExpired ()-> Bool {
        let formatter = DateFormatter()
        if let utcDate = formatter.datefromUdacityApiString(self) {
            return Date().compare(utcDate) == .orderedDescending
        }
        
        return false
    }
}