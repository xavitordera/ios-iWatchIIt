//
//  TabBarVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 27/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false
        
        let moviesVC = HomeRouter.shared.createMoviesModule()
        let navMovies = UINavigationController.init(rootViewController: moviesVC)
        navMovies.tabBarItem.image = kTabMoviesImg
        navMovies.tabBarItem.title = "tab_bar_movies".localized
        
        let shows = HomeRouter.shared.createShowsModule()
        let navShows = UINavigationController.init(rootViewController: shows)
        navShows.tabBarItem.image = kTabShowsImg
        navShows.tabBarItem.title = "tab_bar_shows".localized
        
        viewControllers = [navShows, navMovies]
    }
}
