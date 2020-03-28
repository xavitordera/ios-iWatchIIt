//
//  HomeVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class HomeVC: BaseVC, HomePresenterToViewProtocol, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    var mainTV: UITableView?
    var sections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupNav(title: String) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        self.navigationItem.title = title
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func setupSections() {
        sections.append(kHomeTrendingSection)
        sections.append(kHomeDiscoverSection)
        sections.append(kHomeWatchlistSection)
    }
    
    func setupTV(mediaType: MediaType) {
        mainTV = UITableView(frame: self.view.frame)
        mainTV?.delegate = self
        mainTV?.tableFooterView = UIView()
        mainTV?.allowsSelection = false
        mainTV?.register(UINib(nibName: kInfiniteCarouselTVC, bundle: .main), forCellReuseIdentifier: kInfiniteCarouselTVC)
        mainTV?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        mainTV?.separatorStyle = .none
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kHeightHomeSectionsInfiniteCarousel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    func cellForTrending() -> UITableViewCell {
        if let cell = mainTV?.dequeueReusableCell(withIdentifier: kInfiniteCarouselTVC) as? InfiniteCarouselTVC {
            cell.configureCell(homeContentResponse: home?.trending, title: "home_trending".localized, isHiddingSeeMore: true)
            return cell
        }
        return UITableViewCell()
    }
    
}
