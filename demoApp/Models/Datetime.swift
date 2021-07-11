

import Foundation

// MARK: - Datetime
struct Datetime: Decodable, Equatable {
    
    private let timestamp: Double
    
    private var tz: String
    
    var timeZoneAppliedDate: Date? {
        if let timeZone = TimeZone(abbreviation: tz) {
            return self.toDate().convertToTimeZone(timeZone)
        }
        return nil
    }
    
    var stringForDateWithTimeZoneApplied: String {
        return self.timeZoneAppliedDate?.toTimeString(.short) ?? backupTimeString()
    }
    
    private func backupTimeString() -> String {
            return "\(self.timestamp.toDate()) + \(self.tz)"
    }
}

extension Datetime {
    
    func toDate() -> Date {
        
        let date = Date(timeIntervalSince1970: self.timestamp)
        return date
    }
    
}
