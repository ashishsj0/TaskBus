//
//  FlixError.swift
//  demoApp
//
//  Created by Ashish Sharma on 05/07/21.
//

import Foundation

enum FlixError: String,Error, CustomStringConvertible {
    
    var title: String {
        return "Oops"
    }
    
    var description: String {
        return self.rawValue
    }
    
    case couldNotGetData = "Could not get Data"
    case internalError = "Oops, some error occured, but hey we're working on it."
    case noInternet = "No Internet Connection"
    
   
}

extension FlixError {
    static func getTitleFor(_ err: FlixError) -> String {
        return err.rawValue
    }
}
