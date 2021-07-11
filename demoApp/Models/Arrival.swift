
import Foundation

// MARK: - Arrival
struct ArrivalAndDeparture: Codable {
    let throughTheStations: String?
    let datetime: Datetime?
    let lineDirection: String?
    let route: [Station]?
    let rideID: Int?
    let tripUid: String?
    let hasTracker, isCancelled: Bool?
    let lineCode, direction: String?

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

// MARK: Arrival convenience initializers and mutators

extension ArrivalAndDeparture {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ArrivalAndDeparture.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        throughTheStations: String?? = nil,
        datetime: Datetime?? = nil,
        lineDirection: String?? = nil,
        route: [Station]?? = nil,
        rideID: Int?? = nil,
        tripUid: String?? = nil,
        hasTracker: Bool?? = nil,
        isCancelled: Bool?? = nil,
        lineCode: String?? = nil,
        direction: String?? = nil
    ) -> ArrivalAndDeparture {
        return ArrivalAndDeparture(
            throughTheStations: throughTheStations ?? self.throughTheStations,
            datetime: datetime ?? self.datetime,
            lineDirection: lineDirection ?? self.lineDirection,
            route: route ?? self.route,
            rideID: rideID ?? self.rideID,
            tripUid: tripUid ?? self.tripUid,
            hasTracker: hasTracker ?? self.hasTracker,
            isCancelled: isCancelled ?? self.isCancelled,
            lineCode: lineCode ?? self.lineCode,
            direction: direction ?? self.direction
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
