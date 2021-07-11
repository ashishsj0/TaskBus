//
//  NetworkHelperTest.swift
//  demoAppTests
//
//  Created by Ashish Sharma on 06/07/21.
//

import XCTest
import Network
@testable import demoApp

class NetworkHelperTest: XCTestCase {

    var interface: NetworkInterfaceMock!
    var networkHelper: NetworkHelper!
    
    override func setUp() {
        interface = NetworkInterfaceMock()
        networkHelper = NetworkHelper(interface: interface)
    }

    override func tearDownWithError() throws {
        super.tearDown()
        networkHelper = nil
        interface = nil
    }

    
    func testDecodingTimeTable_ExpectsJSON_ReturnsTimeTableType() throws {
        if let path = Bundle.main.path(forResource: "MockData", ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    
            XCTAssertNoThrow(try JSONDecoder().decode(TimeTables.self, from: data))
        }
        }

    func testFailingDecodingTimeTable_ExpectsInvalidJson() throws {
        if let path = Bundle.main.path(forResource: "MockDataInvalid", ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    
            XCTAssertThrowsError(try JSONDecoder().decode(TimeTables.self, from: data))
        }
        }
    
    func testNetworkInterfaceAndHelperRequestEquality_TakesNetworkAndInterface() {
       
        
        let stationID: Int = 1 // station id of berlin in mockdata.json

        
        let req = URLRequest(url: URL(string: "https://global.api-dev.flixbus.com/mobile/v1/network/station/\(stationID)/timetable")!)
        
        networkHelper.fetchTimeTable(from: req) { _ in }
        
        XCTAssertEqual(interface.request , req)
        
    }
    
    func testRequestStationIDMatch() {
       
        let stationID: Int = 1 // station id of berlin in mockdata.json
        var result: Result<TimeTables, Error>?
        
        let req = URLRequest(url: URL(string: "https://global.api-dev.flixbus.com/mobile/v1/network/station/\(stationID)/timetable")!)
        
        networkHelper.fetchTimeTable(from: req) {
            result = $0
        }
        
        switch result {
        case .success(let timetable):
            XCTAssertEqual(timetable.station.id, stationID)
    
        default:
            break
        }
    }
}

class NetworkInterfaceMock: NetworkInterface {
    
    private (set) var request: URLRequest?
    typealias Handler = NetworkInterface.dataTaskHandler
    
    func request(_ request: URLRequest, completion: @escaping dataTaskHandler) {
        
        self.request = request
        
                    if let path = Bundle.main.path(forResource: "MockData", ofType: "json") {
                        do {
                            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                            completion(data, nil, nil)
                 
                        } catch { }
                    }
                    else {
                        completion(nil, nil, FlixError.internalError)
                        
                    }
                }
        
}
