//
//  NetworkHelper.swift
//  demoApp
//
//  Created by Ashish Sharma on 05/07/21.
//

import Foundation
import Network

protocol NetworkInterface {
    typealias dataTaskHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest, completion: @escaping dataTaskHandler)
}

extension URLSession: NetworkInterface {
    
    typealias dataTaskHandler = NetworkInterface.dataTaskHandler
    
    func request(_ request: URLRequest, completion: @escaping dataTaskHandler) {
        let monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue.global(qos: .background))
        
            monitor.pathUpdateHandler = { path  in
                
                if monitor.currentPath.status == .satisfied {
                    let task = self.dataTask(with: request,completionHandler: completion)
                    task.resume()
                    DispatchQueue.main.async {
                        monitor.cancel()
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil,nil,FlixError.noInternet)
                    }
                }
                
            }
//        }
        
    }
}

class NetworkHelper {
    
    private let interface: NetworkInterface
    
    init(interface: NetworkInterface = URLSession.shared) {
        self.interface = interface
    }
    
    func fetchTimeTable(from request: URLRequest, completion: @escaping (Result<TimeTables,Error>) -> Void) {
           
        interface.request(request) { (data, response, err) in
            
            if (err != nil) {
                completion(.failure(err!)) // nil condition checked, so force unwrapping should be fine here.
            }
            
            // ignoring error and response for now, just trying to get the value of data, if not found sh
            
            if let data = data {
            
                do {
                    completion(.success(try JSONDecoder().decode(TimeTables.self,from: data)))
                }
                catch {
                    // catched exception would be a runtime logical error, that's usually irrelavant to the end user
                    completion(.failure(FlixError.internalError))
                }
            }
            else {
                
                completion(.failure(FlixError.couldNotGetData))
                return
            }
            
        }
        
       }
    
}
