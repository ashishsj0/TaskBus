

import Foundation

// MARK: - Timetable
struct Timetable: Decodable {
    var arrivals, departures: [ArrivalAndDeparture]
    let message: String
}
