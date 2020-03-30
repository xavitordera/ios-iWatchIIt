//
//  HomeVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class HomeVC: BaseVC, HomePresenterToViewProtocol, UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, InfiniteCarouselTVCDelegate {
    
    var mainTV: UITableView?
    var sections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTV()
    }
    
    func setupNav(title: String, type: MediaType) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = title
        
        let searchVC = SearchRouter.shared.createModule()
        searchVC.type = type
        
        let search = UISearchController(searchResultsController: searchVC)
        search.searchResultsUpdater = self
        search.delegate = self
        search.searchBar.delegate = searchVC
        definesPresentationContext = true
        self.navigationItem.searchController = search
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func setupSections() {
        sections.append(kHomeTrendingSection)
        sections.append(kHomeDiscoverSection)
        sections.append(kHomeWatchlistSection)
    }
    
    func setupTV() {
        mainTV = UITableView(frame: self.view.frame)
        mainTV?.delegate = self
        mainTV?.dataSource = self
        mainTV?.tableFooterView = UIView()
        mainTV?.allowsSelection = false
        mainTV?.register(UINib(nibName: kInfiniteCarouselTVC, bundle: .main), forCellReuseIdentifier: kInfiniteCarouselTVC)
        mainTV?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        mainTV?.separatorStyle = .none
        setupSections()
        view = (mainTV!)
    }
    
    func loadData(mediaType: MediaType) {
        guard let presenter = getPresenter() else { return }
        presenter.startFetchingData(type: mediaType)
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.row] {
        case kHomeTrendingSection:
            return kHeightHomeSectionsInfiniteCarousel - 20
        default:
            return kHeightHomeSectionsInfiniteCarousel
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case kHomeTrendingSection:
            return cellForTrending()
        case kHomeDiscoverSection:
            return cellForDiscover()
        case kHomeWatchlistSection:
            return cellForWatchlist()
        default:
            return UITableViewCell()
        }
    }
    
    func cellForTrending() -> UITableViewCell {
        if let cell = mainTV?.dequeueReusableCell(withIdentifier: kInfiniteCarouselTVC) as? InfiniteCarouselTVC, let presenter = getPresenter() {
            cell.configureCell(homeContentResponse: presenter.home?.trending, isHiddingSeeMore: true)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func cellForDiscover() -> UITableViewCell {
        if let cell = mainTV?.dequeueReusableCell(withIdentifier: kInfiniteCarouselTVC) as? InfiniteCarouselTVC, let presenter = getPresenter() {
            cell.configureCell(homeContentResponse: presenter.home?.discover, isHiddingSeeMore: true)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func cellForWatchlist() -> UITableViewCell {
        if let cell = mainTV?.dequeueReusableCell(withIdentifier: kInfiniteCarouselTVC) as? InfiniteCarouselTVC, let presenter = getPresenter() {
            cell.configureCell(homeContentResponse: presenter.home?.watchlist, isHiddingSeeMore: false)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Cell delegates
    
    func didTapContentCell(id: Int) {
        // TODO: go detail!!
        debugPrint("Content tapped: \(id)")
        RecentlySeenHelper.saveRecentlySeen(id: id, title: "stfu bitch you issa crazy hoe", mediaType: .movie)
    }
    
    func didTapSeeMore(section: HomeSectionType) {
        // TODO: go see more!!
        debugPrint("see more tapped on section: \(section)")
    }
    
    // MARK: - Presenter delegate
    
    func onDataFetched() {
        mainTV?.reloadData()
    }
    
    // MARK: - Auxiliar functions
    func getPresenter() -> HomeViewToPresenterProtocol? {
        guard let presenter = self.presenter as? HomeViewToPresenterProtocol else {
            showError(message: "app_error_generic".localized)
            return nil
        }
        return presenter
    }
}
