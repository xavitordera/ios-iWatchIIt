
//
//  File.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

class APIService {
    
    static let shared: APIService = APIService()
    
    // MARK: - The movie DB services
    
    /// Configuration
    func getConfiguration(completion: @escaping () -> Any) {
        
    }
    // GET -> /configuration
    // Store in Realm
    
    // Home Services
    // GET -> getTrendingMovies
    // GET -> getTrendingTVShows
    // GET -> discoverMovies
    // GET -> discoverTVShows
    
    /// Detail services
    // GET -> getDetails
    // GET -> getVideos
    // GET -> getReviews
    // GET -> getSimilarMovies
    // GET -> getSimilarTVShows
}
