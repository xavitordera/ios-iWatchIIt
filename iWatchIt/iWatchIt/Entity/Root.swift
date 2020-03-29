//
//  Root.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//



struct Root: Decodable {
    var page: Int = 1
    var totalPages: Int = 1
    var totalResults: Int = 1
    var results: [Content]?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct RootExtended: Decodable {
    var page: Int = 1
    var totalPages: Int = 1
    var totalResults: Int = 1
    var results: [ContentExtended]?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Content: Decodable {
    var image: String = ""
    var id: Int = 0
    var voteAverage: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
        case id = "id"
        case voteAverage = "vote_average"
    }
}

struct ContentExtended: Decodable {
    var image: String = ""
    var id: Int = 0
    var voteAverage: Double = 0.0
    var title: String = ""
    var overview: String = ""
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
        case id = "id"
        case voteAverage = "vote_average"
    }
}
