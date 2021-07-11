//
//  TableControllerViewModelTest.swift
//  demoAppTests
//
//  Created by Ashish Sharma on 07.07.21.
//

import XCTest
@testable import demoApp

class TableControllerViewModelTest: XCTestCase {

    var model: TimeTableControllerViewModel!
    
    override func setUp() {
        super.setUp()
        
        if let path = Bundle.main.path(forResource: "MockData", ofType: "json") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    
            model = .init(try! JSONDecoder().decode(TimeTables.self, from: data!))
        }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        model = nil
    }

    func testGetNumberOfSections_ReturnsTableSourceCount() {
       
        // setting model ordering by arrival
        // Arrival has 2 different Dates hence should return 2 sections
        
        model.setOrderBasedOnArrivalTime(true)
        XCTAssertEqual(model?.getNumberOfSections(), 2)
        
        // Setting Departure, it has one date
        model.setOrderBasedOnArrivalTime(false)
        
        // Failing case, testing not equal, then passing case of 1
        XCTAssertNotEqual(model.getNumberOfSections(), 5)
        XCTAssertEqual(model.getNumberOfSections(), 1)
    }
    
    func testSetGetCityTitle() {
        XCTAssertEqual(model?.getCurrentCityTitle(), "Berlin")
        
        model.setSearchingCity(.munich)
        
        XCTAssertNotEqual(model?.getCurrentCityTitle(), "Berlin")
        XCTAssertEqual(model?.getCurrentCityTitle(), "Munich")
    }
    
    func testFooterForSection() {
        
        // Filtering by Departure
        model.setOrderBasedOnArrivalTime(false)
        
        XCTAssertEqual(model.getFooterForSection(0).text," ↑ Last Departure on \(model.getTitleForSection(0) ?? " this day")")
        
        // Filtering by Arrival
        
        model.setOrderBasedOnArrivalTime(true)
        
        XCTAssertEqual(model.getFooterForSection(0).text," ↑ Last Arrival on \(model.getTitleForSection(0) ?? " this day")")
        
        // When no data
        
        model?.tableDataSource.value = nil
        XCTAssertEqual(model?.getFooterForSection(0).text,"Nothing to show!")
    }
    
    func testSectionFooterLabel_WhenIncorrectData() {
        
        model.setOrderBasedOnArrivalTime(false)
        
        XCTAssertEqual(model.getFooterForSection(5).text," ↑ Last Departure on this day")
        
        // Filtering by Arrival
        
        model.setOrderBasedOnArrivalTime(true)
        
        XCTAssertEqual(model.getFooterForSection(5).text," ↑ Last Arrival on this day")
        
        // When no data
        
        model?.tableDataSource.value = nil
        XCTAssertEqual(model?.getFooterForSection(0).text,"Nothing to show!")
        
    }
    
    func testSectionFooterLabel() {
        
        model.setOrderBasedOnArrivalTime(false)
        XCTAssertEqual(model.getTitleForSection(0), "Monday, Jul 5, 2021")
        
    }
    

}
