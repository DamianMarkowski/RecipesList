//
//  HTTPClient.swift
//  Recipes
//
//  Created by Damian Markowski on 24.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import Foundation

class HTTPClient {
    
    private let session: URLSession!
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func get(_ url: URL, completionHandler: @escaping ( _ data: Data?, _ error: Error?)->()) {
        let task = session.dataTask(with: createRequest(url)) {
            (
            data, response, error) in
            completionHandler(data,error)
        }
        task.resume()
    }
    
    private func createRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
