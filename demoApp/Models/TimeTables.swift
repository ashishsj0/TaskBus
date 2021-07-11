
import Foundation

// MARK: - TimeTables

//This struct is not used as as we are not doing anything station relevant.

struct TimeTables: Decodable {
    var timetable: Timetable
    var station: Station
}

