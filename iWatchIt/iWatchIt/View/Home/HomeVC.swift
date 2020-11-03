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
    var type: MediaType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupNav(title: String, type: MediaType) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = title
        self.type = type
        
        let searchVC = SearchRouter.shared.createModule()
        searchVC.type = type
        searchVC.nav = navigationController
        
        let search = UISearchController(searchResultsController: searchVC)
        search.searchResultsUpdater = self
        search.delegate = self
        search.searchBar.delegate = searchVC
        search.searchBar.placeholder = (type == .movie) ? "home_search_movies".localized : "home_search_shows".localized
        definesPresentationContext = true
        self.navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func setupSections() {
        sections.append(kHomeTrendingSection)
        sections.append(kHomeDiscoverSection)
        sections.append(kHomeTopRatedSection)
        sections.append(kHomeWatchlistSection)
        sections.append(kSectionCopyright)
    }
    
    func setupTV() {
        mainTV = UITableView(frame: self.view.frame)
        mainTV?.delegate = self
        mainTV?.dataSource = self
        mainTV?.tableFooterView = UIView()
        mainTV?.allowsSelection = false
        mainTV?.register(UINib(nibName: kInfiniteCarouselTVC, bundle: .main), forCellReuseIdentifier: kInfiniteCarouselTVC)
        mainTV?.register(cellType: BannerAdTVC.self)
        mainTV?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        mainTV?.separatorStyle = .none
        setupSections()
        mainTV?.tableHeaderView = viewForBanner(size: CGSize(width: view.frame.width, height: kHeightBannerAd))
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
        switch sections[indexPath.section] {
        case kHomeTrendingSection:
            return kHeightHomeSectionsInfiniteCarousel - 20
        case kSectionCopyright:
            return kHeightBannerAd
        default:
            return kHeightHomeSectionsInfiniteCarousel
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case kHomeTrendingSection:
            return cellForSection(getPresenter()?.home?.trending)
        case kHomeDiscoverSection:
            return cellForSection(getPresenter()?.home?.discover)
        case kHomeTopRatedSection:
            return cellForSection(getPresenter()?.home?.topRated)
        case kHomeWatchlistSection:
            return cellForSection(getPresenter()?.home?.watchlist)
        case kSectionCopyright:
            return cellForCopyright(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func cellForSection(_ section: HomeSection?) -> UITableViewCell {
        if let cell = mainTV?.dequeueReusableCell(withIdentifier: kInfiniteCarouselTVC) as? InfiniteCarouselTVC {
            cell.configureCell(homeContentResponse: section, isHiddingSeeMore: true)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func cellForCopyright(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTV?.dequeueReusableCell(for: indexPath, cellType: BannerAdTVC.self) else { return UITableViewCell() }
        
        cell.configureWithBanner(banner: UIImageView(image: kTMBDLogo))
        
        return cell
    }
    
    // MARK: - Cell delegates
    
    func didTapContentCell(id: Int) {
        if let presenter = getPresenter() {
            presenter.contentSelected(navigationController: self.navigationController!, for: id, and: self.type!)
        }
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
