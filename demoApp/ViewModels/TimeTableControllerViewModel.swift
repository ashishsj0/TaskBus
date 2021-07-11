//
//  TimeTableControllerViewModel.swift
//  demoApp
//
//  Created by Ashish Sharma on 05.07.21.
//

import Foundation
import UIKit

class TimeTableControllerViewModel {
    
    // Enums can be made global if required at more than one place, accessible to this class is suitable for current use case
    
    enum RequestState {
        case loading
        case failedWithError(Error)
        case done
    }
    
    enum City: Int {
        case berlin = 1
        case munich = 10
    }
    
    //MARK: Public Properties
    var tableDataSource: Observable<Dictionary<String,[ArrivalAndDeparture]>> = Observable.init([:])
    
    var currentRequestState: Observable<RequestState> = Observable.init(RequestState.done)
    
    //MARK: Private Properties
    
    private var networkHelper = NetworkHelper()
    
    private var timetables: TimeTables? {
        didSet {
            self.createTableDataSource()
        }
    }
    
    private var orderBasedOnArrivalTime: Bool = false {
        didSet {
            self.createTableDataSource()
        }
    }
    
    private var searchForCity: City = .berlin {
        didSet {
            self.fetchTimeTables()
        }
    }
    
    //MARK: Public Methods
    
    /// Use this function to select result ordering
    /// - Parameter value: if true results will be ordered based on arrival, otherwise departure
    
    func setOrderBasedOnArrivalTime(_ value: Bool) {
        self.orderBasedOnArrivalTime = value
    }
    
    /// Set search city for the view model
    /// - Parameter city: value of enum City
    
    func setSearchingCity(_ city: City) {
        self.searchForCity = city
    }
    
    
    /// returns the number of sections
    /// - Returns: Integer value specifying the number of objects in datasource
    
    func getNumberOfSections() -> Int {
        self.tableDataSource.value?.count ?? 0
    }
    
    /// returns the number of rows in a section
    /// - Parameter section: section number less than the number of sections in source and positive.
    /// - Returns: Integer value specifying the number of objects in datasource
    
    func getNumberOfRows(_ section: Int) -> Int {
        if let dict = self.tableDataSource.value, section < self.getNumberOfSections(), section >= 0 {
            return dict[dict.index(dict.startIndex, offsetBy: section)].value.count
        }
        return 0
    }
    
    
    
    /// Use this to recive titles for sections in table.
    /// - Parameter section: section number less than the number of sections in source and positive.
    /// - Returns: returns the key for grouped table data source
    
    func getTitleForSection(_ section: Int) -> String? {
        if let dict = self.tableDataSource.value, self.getNumberOfSections() != 0, section >= 0, section < self.getNumberOfSections(){
            return dict[dict.index(dict.startIndex, offsetBy: section)].key
        }
        return nil
    }
    
    /// Use this to get a footer view for sections
    /// - Parameter section: section number for which label is required.
    /// - Returns: UILabel with title and font according to Arrival/Departure selection
    
    func getFooterForSection(_ section: Int) -> UILabel {
        let lbl = UILabel(frame: .infinite)
        
        if self.getNumberOfSections() > 0 {
            lbl.font = .italicSystemFont(ofSize: 11)
            lbl.text = " ↑ Last \(self.orderBasedOnArrivalTime ? "Arrival" : "Departure") on \(self.getTitleForSection(section) ?? "this day")"
            
        } else {
            lbl.font = .boldSystemFont(ofSize: 13)
            lbl.text = "Nothing to show!"
        }
        
        lbl.textAlignment = .center
        return lbl
    }
    
    /// Use this to get the title of currently selected city
    /// - Returns: Capitalized String value of selected city.
    
    func getCurrentCityTitle() -> String {
        return "\(self.searchForCity)".capitalized
    }
    
    func getItemAtIndex(_ indexPath: IndexPath) -> ArrivalAndDeparture? {
        if let dict = self.tableDataSource.value {
            return dict[dict.index(dict.startIndex, offsetBy: indexPath.section)].value[indexPath.row]
        }
        return nil
    }
    
    //MARK: init
    init() {}
    
    init(_ timeTables: TimeTables) {
        self.timetables = timeTables
        self.createTableDataSource()
    }
    
    //MARK: Private Methods
    
    private func createTableDataSource() {
        
        if let tempData = self.orderBasedOnArrivalTime ? self.timetables?.timetable.arrivals : self.timetables?.timetable.departures {
                
            self.tableDataSource.value = Dictionary.init(grouping: tempData, by: { val in
                val.datetime.timeZoneAppliedDate?.toDateString(.toDateWithDay) ?? ""
            })

        } else {
            self.tableDataSource.value?.removeAll()
        }
    }
    
    private func fetchTimeTables() {
        
        // this request call can be further abstracted
        // eg. API Manager class to get a constructed APIRequest or EndPoint enum to get Base Url and enpoints
        // as for the use case only a single API was to be called, I chose to do it this way.
        
        self.currentRequestState.value = .loading
        self.timetables = nil
        guard let url = URL(string: "https://global.api-dev.flixbus.com/mobile/v1/network/station/\(searchForCity.rawValue)/timetable") else {
            
            self.currentRequestState.value = .failedWithError(FlixError.couldNotGetData)
            
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("intervIEW_TOK3n", forHTTPHeaderField: "X-Api-Authentication")
        
        self.networkHelper.fetchTimeTable(from: request) { [weak self] result in
            switch result {
            case .success(let timeTable):
                self?.timetables = timeTable
                self?.currentRequestState.value = .done
                
            case .failure(let error):
               
                self?.currentRequestState.value = .failedWithError(error)
                
            }
        }
    }
}
