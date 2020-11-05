//
//  URL+Utils.swift
//  iWatchIt
//
//  Created by Xavier Tordera on 05/11/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation


extension URL {
    
    /// Looks in the url parameters for the specified param name, if it finds it, it changes its value, else, it adss the parameter
    /// - Parameters:
    ///   - paramName: the name of the parameter to look for
    ///   - paramValue: the desired value of the parameter
    /// - Returns: URL with the tweaked parameter or self if the operation failed
    func urlWithTweakedURLParams(paramName: String, paramValue: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            var queryItems = components.queryItems
            else { return self }
        
        let queryItem = URLQueryItem(name: paramName, value: paramValue)
        
        if let index = queryItems.firstIndex(where: { $0.name == paramName }) {
            queryItems[index] = queryItem
        } else {
            queryItems.append(queryItem)
        }
        
        components.queryItems = queryItems
        
        let url = try? components.asURL()
        
        return url ?? self
    }
    
}
