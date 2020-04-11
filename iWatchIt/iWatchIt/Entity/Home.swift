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
    static var homeShows = Home()
    static var homeMovies = Home()
    
    static func updateFromRoot(rootTrending: Root?, rootDiscover: Root?, watchlist: [WatchlistContent]?, type: MediaType) -> Home? {
        if let rootTren = rootTrending {
            var trending = HomeSection()
            trending.content = rootTren.results
            trending.title = "home_section_trending".localized
            trending.type = .Trending
            switch type {
            case .movie:
                homeMovies.trending = trending
            case .show:
                homeShows.trending = trending
            }
        }
        if let rootDisc = rootDiscover {
            var discover = HomeSection()
            discover.content = rootDisc.results
            discover.title = "home_section_discover".localized
            switch type {
            case .movie:
                homeMovies.discover = discover
            case .show:
                homeShows.discover = discover
            }
        }
        if let watchlist = watchlist {
            var wsHome = HomeSection()
            wsHome.title = "home_section_watchlist".localized
            wsHome.content = []
            for watchli in watchlist {
                var content = Content()
                content.id = watchli.id
                content.image = watchli.image
                content.voteAverage = watchli.voteAverage
                wsHome.content?.append(content)
            }
            wsHome.type = .Watchlist
            switch type {
            case .movie:
                homeMovies.watchlist = wsHome
            case .show:
                homeShows.watchlist = wsHome
            }
        }
        switch type {
        case .movie:
            return homeMovies
        case .show:
            return homeShows
        }
    }
}
