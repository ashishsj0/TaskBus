//
//  TimeTableTableViewCellViewModel.swift
//  demoApp
//
//  Created by Ashish Sharma on 06.07.21.
//

import Foundation

class TimetableTableViewCellViewModel {
    
    var data: ArrivalAndDeparture!
    
    init(data: ArrivalAndDeparture) {
        self.data = data
    }
    
    /// returns short time of a route
    var shortTime: String {
        get {
            return data.datetime.stringForDateWithTimeZoneApplied
        }
    }
    
    /// Returns direction of a line
    var lineDirection: String? {
        get {
            return data.lineDirection
        }
    }
    
    /// returns the complete route string
    var routeString: String {
        get {
            return (self.data.route).reduce("", { (res, nex) in
                res.appending((nex.name) + (nex != data.route.last ? " → " : ""))
            })
        }
    }
    
}
