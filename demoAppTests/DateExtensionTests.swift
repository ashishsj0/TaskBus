//
//  StringExtensionTests.swift
//  demoAppTests
//
//  Created by Ashish Sharma on 06.07.21.
//

import XCTest
@testable import demoApp

class DateExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        
    }
    
    func testDoubleToDate_expectsTimestampInDouble_returnsDate() {
        
        let timestamp: Double = 1625056413 // june 2021
        let timestampInFuture: Double = 4102320813 // dec 2099
        XCTAssertLessThan(timestamp.toDate(), Date())
        XCTAssertGreaterThan(timestampInFuture.toDate(), Date())
    }
    
    func testDateToString_expectsDate_returnsString() {
       
        let date = Date(timeIntervalSince1970: 1625011200) //  2021-06-30
        let dateWithTime = Date(timeIntervalSince1970: 1625056413) //  2021-06-30 14:33:33
        XCTAssertEqual(dateWithTime.toDateString(), "2021-06-30 14:33:33")
        XCTAssertEqual(date.toDateString(.toDateWithDay), "Wednesday, Jun 30, 2021")
        
    }
    
    func testDateToTimeString_expectsDate_returnsTimeString() {
       
        let dateWithTime = Date(timeIntervalSince1970: 1625056413) //  2021-06-30 14:33:33
        XCTAssertEqual(dateWithTime.toTimeString(), "14:33")
        XCTAssertEqual(dateWithTime.toTimeString(.longWithMicroSeconds), "14:33:33.000")
        XCTAssertEqual(dateWithTime.toTimeString(.mid), "14:33:33")
        
    }

}
