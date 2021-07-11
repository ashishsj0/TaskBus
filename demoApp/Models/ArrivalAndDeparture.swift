
import Foundation

// MARK: - Arrival
struct ArrivalAndDeparture: Decodable {
    let throughTheStations: String
    let datetime: Datetime
    let lineDirection: String
    let route: [Station]
    let rideID: Int
    let tripUid: String
    let hasTracker, isCancelled: Bool
    let lineCode, direction: String

    enum CodingKeys: String, CodingKey {
        case throughTheStations = "through_the_stations"
        case datetime
        case lineDirection = "line_direction"
        case route
        case rideID = "ride_id"
        case tripUid = "trip_uid"
        case hasTracker = "has_tracker"
        case isCancelled = "is_cancelled"
        case lineCode = "line_code"
        case direction
    }
    
   
}
