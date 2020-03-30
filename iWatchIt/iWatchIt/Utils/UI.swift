//
//  UI.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 26/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit


let kFakeSpashVC = "FakeSplashVC"
let kHomeVC = "HomeVC"
let kMoviesVC = "MoviesVC"
let kShowsVC = "ShowsVC"
let kTabBarVC = "TabBarVC"
let kSearchVC = "SearchVC"


let kHomeTrendingSection = "Trending"
let kHomeDiscoverSection = "You might like..."
let kHomeWatchlistSection = "Your watchlist"

let kLogoAnimation = "ic_loading_splash"


var kStoryboardMain: UIStoryboard{
    return UIStoryboard(name:"Main",bundle: Bundle.main)
}



let kTabMoviesImg = UIImage(named:"ic_tab_movies")
let kTabShowsImg = UIImage(named:"ic_tab_shows")
let kEmptyStateMedia = UIImage(named: "emptyStateMedia")



let kHeightHomeSectionsInfiniteCarousel: CGFloat = 280
let kHomeSectionsInfiniteCarouselImageSize: ImageSize = .poster(size: PosterSize.medium)


let kInfiniteCarouselTVC = "InfiniteCarouselTVC"
let kInfiniteCarouselCVC = "InfiniteCarouselCVC"
let kSectionHeader = "SectionHeader"
let kDefaultCell = "defaultCell"
