//
//  TabBarVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 27/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

enum IndexTabBar: Int {
    case movies = 0
    case shows
    case discover
}

final class TabBarVC: UITabBarController {
    
    private var navigationControllers: [UINavigationController]?
    private var lastIndex: IndexTabBar = .movies
    
    static var isTabBarInitialized = false
    static var queue: [() -> ()] = []
    
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
        
        let discover = DiscoverRouter.shared.createModule()
        let navDiscover = UINavigationController.init(rootViewController: discover)
        navDiscover.tabBarItem.image = kTabDiscoverImg
        navDiscover.tabBarItem.title = "tab_bar_discover".localized
        
        navigationControllers = [navShows, navMovies, navDiscover]
        viewControllers = navigationControllers
        
        TabBarVC.isTabBarInitialized = true
        
        if !TabBarVC.queue.isEmpty {
            TabBarVC.queue.forEach { task in
                DispatchQueue.main.async {
                    task()
                }
            }
        }

        if #available(iOS 15.0, *) {
           let appearance = UITabBarAppearance()
           appearance.configureWithOpaqueBackground()
           tabBar.standardAppearance = appearance
           tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }

        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    func navigateTo(_ viewController: UIViewController) {
        let navController = navigationControllers?[lastIndex.rawValue]
        navController?.pushViewController(viewController, animated: true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            lastIndex = IndexTabBar(rawValue: index) ?? .movies
        }
    }
    
    static func enqueue(task: @escaping () -> ()) {
        queue.append(task)
    }
}
