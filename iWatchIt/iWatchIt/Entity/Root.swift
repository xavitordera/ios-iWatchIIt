//
//  Root.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//



struct Root: Decodable {
    var page: Int?
    var results: [Content]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
    }
}

struct RootExtended: Decodable {
    var page: Int?
    var totalPages: Int?
    var totalResults: Int?
    var results: [ContentExtended]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Content: Decodable {
    var image: String?
    var id: Int?
    var voteAverage: Double?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
        case id
        case voteAverage = "vote_average"
        case title
    }
}

struct ContentExtended: Decodable {
    var image: String?
    var id: Int?
    var voteAverage: Double?
    var title: String?
    var overview: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
        case id
        case voteAverage = "vote_average"
        case title
        case overview
    }
}
