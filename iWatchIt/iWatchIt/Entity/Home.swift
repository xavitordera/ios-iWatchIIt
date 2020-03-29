//
//  Home.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

enum MediaType: String {
    case movie = "movie"
    case show = "tv"
}

enum HomeSectionType {
    case Trending
    case Discover
    case Watchlist
}

struct HomeContent: Decodable {
    var image: String = ""
    var id: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
        case id = "id"
    }
}


struct HomeSection {
    var title: String = ""
    var content: [HomeContent]?
    var type: HomeSectionType = .Trending
}

struct Home {
    var trending: HomeSection?
    var discover: HomeSection?
    var watchlist: HomeSection?
    
    static func createFromRoot(rootTrending: Root?, rootDiscover: Root?) -> Home? {
        var home = Home()
        var trending = HomeSection()
        trending.content = rootTrending?.results
        trending.title = "home_section_trending".localized
        trending.type = .Trending
        home.trending = trending
        trending.title = "home_section_discover".localized
        home.discover = trending
        trending.title = "home_section_watchlist".localized
        home.watchlist = trending
        return home
    }
}


struct Root: Decodable {
    var page: Int = 1
    var results: [HomeContent]?
}
