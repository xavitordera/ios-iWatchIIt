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

struct HomeSection {
    var title: String = ""
    var content: [Content]?
    var type: HomeSectionType = .Trending
}

struct Home {
    var trending: HomeSection?
    var discover: HomeSection?
    var watchlist: HomeSection?
    static var home = Home()
    
    static func updateFromRoot(rootTrending: Root?, rootDiscover: Root?) -> Home? {
        if let rootTren = rootTrending {
            var trending = HomeSection()
            trending.content = rootTren.results
            trending.title = "home_section_trending".localized
            trending.type = .Trending
            home.trending = trending
            trending.title = "home_section_watchlist".localized
            home.watchlist = trending
            home.watchlist?.type = .Watchlist
        }
        if let rootDisc = rootDiscover {
            var discover = HomeSection()
            discover.content = rootDisc.results
            discover.title = "home_section_discover".localized
            home.discover = discover
        }
        return home
    }
}
