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
    var totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
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
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
        case id
        case voteAverage = "vote_average"
        case title
        case name
    }
}

struct ContentExtended: Decodable {
    var image: String?
    var id: Int?
    var voteAverage: Double?
    var title: String?
    var name: String?
    var overview: String?
    var genres: [Genre]?
    var runtime: Int?
    var movieReleaseDate: String?
    var firstAirDate: String?
    var videos: RootVideo?
    var credits: RootCast?
    var numberOfSeasons: Int?
    var numberOfEpisodes: Int?
    var originalName: String?
    var originalTitle: String?
    var externalIDs: ContentExternalId?
    var similar: Root?
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
        case id
        case voteAverage = "vote_average"
        case title
        case name
        case overview
        case genres
        case runtime
        case movieReleaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case videos
        case credits
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case externalIDs = "external_ids"
        case similar = "similar"
    }
}

struct RootVideo: Decodable {
    var results: [Video]?
}

struct RootCast: Decodable {
    var cast: [Cast]?
}

struct RootPlatform: Decodable {
    var collection: RootCollection?
}

struct RootCollection: Decodable  {
    var locations: [Platform]?
}

struct RootPeople: Decodable {
    var results: [People]?
}

struct RootKeyword: Decodable {
    var results: [Keyword]?
}

struct RootGenres: Decodable {
    var genres: [Genre]?
}
