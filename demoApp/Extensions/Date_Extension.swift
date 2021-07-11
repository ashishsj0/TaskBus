//
//  Date_Extension.swift
//  demoApp
//
//  Created by Ashish Sharma on 05/07/21.
//

import Foundation


extension Date {
    
    enum DateType: String {
        case toDateWithDay = "EEEE, MMM d, yyyy"
        case midDDMMYYYY = "YYYY-MM-dd HH:mm:ss"
    }
    
    enum TimeType: String {
        case longWithMicroSeconds = "HH:mm:ss.SSS"
        case mid = "HH:mm:ss"
        case short = "HH:mm"
    }
    
    func toTimeString(_ type: TimeType = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
    
    func toDateString(_ type: DateType = .midDDMMYYYY) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
            return dateFormatter.string(from: self)
    }
    
    func convertToTimeZone(_ timeZone: TimeZone) -> Date {
        let difference = TimeInterval(timeZone.secondsFromGMT(for: self) - Calendar.current.timeZone.secondsFromGMT())
        return addingTimeInterval(difference)
    }
 
}

extension Double {
    func toDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}
