//
//  URLSessionExtension.swift
//  RNArcGISMapView
//
//  Created by Lane Lu on 2022/9/29.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation

extension URLSession {
    func synchronousGet(with url: URL, params: NSDictionary?) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}
