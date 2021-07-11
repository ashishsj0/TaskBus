//
//  TimeTableCellViewModelTest.swift
//  demoAppTests
//
//  Created by Ashish Sharma on 07.07.21.
//

import XCTest
@testable import demoApp

class TimeTableCellViewModelTest: XCTestCase {

    var model: TimetableTableViewCellViewModel?
    
    override func setUp() {
        super.setUp()
        
        if let path = Bundle.main.path(forResource: "MockData", ofType: "json") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    
            let timetables = (try! JSONDecoder().decode(TimeTables.self, from: data!))
            if let arrivalAndDepartureModel = timetables.timetable.departures.first {
                self.model = .init(data: arrivalAndDepartureModel)
            }
        }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        model = nil
    }
    
    func testShortTime_shouldReturnHHColonMMTimeString() {
        
        XCTAssertEqual(model?.shortTime,"14:30")
        
    }
    
    func testRouteString() {
        
        XCTAssertEqual(model?.routeString,"Berlin central bus station → Münchberg → Bayreuth main station → Munich central bus station")
        
    }
    
    func testRouteDirectionString() {
        
        XCTAssertNotNil(model?.lineDirection)
        
    }
    
}
