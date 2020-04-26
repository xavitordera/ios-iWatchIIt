//
//  DiscoverVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

enum SegmentIndexes: Int {
    case shows = 0
    case movies = 1
}

class DiscoverVC: BaseVC {
    
    // MARK: - Properties
    var sections: [String] = []
    var searchVC: SearchInfoVC?
    
    @IBOutlet weak var mainTV: UITableView! {
        didSet {
            mainTV.register(UINib(nibName: kDiscoverHeaderTHV, bundle: .main), forHeaderFooterViewReuseIdentifier: kDiscoverHeaderTHV)
            mainTV.register(UINib(nibName: kDiscoverSearchTVC, bundle: .main), forCellReuseIdentifier: kDiscoverSearchTVC)
            mainTV.register(UINib(nibName: kDiscoverPeopleTVC, bundle: .main), forCellReuseIdentifier: kDiscoverPeopleTVC)
            mainTV.register(UITableViewCell.self, forCellReuseIdentifier: kDefaultCell)
            mainTV.delegate = self
            mainTV.dataSource = self
            mainTV.bounces = true
            mainTV.allowsSelection = true
            mainTV.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
            mainTV.tableFooterView = UIView()
//            segMediaType.selectedSegmentIndex = 0
//            mainTV.tableHeaderView = segMediaType
        }
    }
    
//    var segMediaType: UISegmentedControl = UISegmentedControl(items: ["discover_tv_shows_tab".localized, "discover_movies_tab".localized])
    
//    var searchButton: UIButton?
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Auxiliar functions
    
    func setupNav() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "discover_title".localized
        
        searchVC = DiscoverRouter.shared.createSearchInfoModule()
        let searchController = UISearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search keywords, genres, people..."
        searchController.searchBar.delegate = self
        searchController.delegate = self
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
//    func setupSearchButton() {
//        searchButton = UIButton(frame: .init(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height - 160, width: 150, height: 40))
//        searchButton?.backgroundColor = .whiteOrBlack
//        searchButton?.setTitleColor(.blackOrWhite, for: .normal)
//        searchButton?.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .regular)
//        searchButton?.setTitle("discover_search".localized, for: .normal)
//        searchButton?.setImage(kTabDiscoverImg, for: .normal)
//        searchButton?.layer.cornerRadius = 14
//        searchButton?.layer.borderColor = UIColor.blackOrWhite.cgColor
//        searchButton?.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
//        searchButton?.addTarget(self, action: #selector(searchTap), for: .touchUpInside)
//
//        view.addSubview(searchButton!)
//    }
    
    func setup() {
        setupNav()
//        setupSearchButton()
        setupSections()
        loadData()
//        setupQueryDelegate()
    }
    
//    func setupQueryDelegate() {
//        DiscoverQuery.shared.addDelegate(delegate: self)
//    }
    
    func setupSections() {
        sections = [
//            kSectionDiscoverGenre,
//            kSectionDiscoverPeople,
//            kSectionDiscoverKeywords
            kHomeTrendingSection
        ]
    }
    
    func loadData() {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.startFetchingTrendingPeople()
            presenter.startFetchingGenres(mediaType: .movie)
            presenter.startFetchingGenres(mediaType: .show)
        }
    }
    
//    func selectedMediaType() -> MediaType {
//        switch SegmentIndexes(rawValue: segMediaType.selectedSegmentIndex) {
//        case .movies:
//            return .movie
//        default:
//            return .show
//        }
//    }
    
    func didSearchKeyword(keyword: String) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.startFetchingKeywords(term: keyword)
        }
    }
    
//    func didSearchGenre(genre: String, mediaType: MediaType) {
//        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
//            if mediaType == .movie {
//                presenter.startFilteringGenres(term: genre, mediaType: .movie)
//            } else {
//                presenter.startFilteringGenres(term: genre, mediaType: .show)
//            }
//        }
//    }
    
    func didSearchGenre(genre: String) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.startFilteringGenres(term: genre) 
        }
    }
    
    func didSearchPeople(people: String) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.startFetchingPeople(term: people)
        }
    }
    
    // MARK: - Actions
    
//    @objc func searchTap() {
//        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self), let nav = navigationController {
//            presenter.startDiscovering(navigationController: nav, query: DiscoverQuery.shared, mediaType: selectedMediaType())
//        }
//    }
    
    // MARK:- UITableview auxiliar functions
    
//    func headerForKeywords() -> UITableViewHeaderFooterView  {
//        guard let header = mainTV.dequeueReusableHeaderFooterView(withIdentifier: kDiscoverHeaderTHV) as? DiscoverHeaderTVC else { return UITableViewHeaderFooterView() }
//        header.configureCell(title: "Keywords")
//        return header
//    }
//
//    func headerForGenres() -> UITableViewHeaderFooterView  {
//        guard let header = mainTV.dequeueReusableHeaderFooterView(withIdentifier: kDiscoverHeaderTHV) as? DiscoverHeaderTVC else { return UITableViewHeaderFooterView() }
//        header.configureCell(title: "Genres")
//        return header
//    }
//
//    func headerForPeople() -> UITableViewHeaderFooterView  {
//        guard let header = mainTV.dequeueReusableHeaderFooterView(withIdentifier: kDiscoverHeaderTHV) as? DiscoverHeaderTVC else { return UITableViewHeaderFooterView() }
//        header.configureCell(title: "People")
//        return header
//    }
    
    func cellForHeader(title: String) -> UITableViewCell {
        guard let cell = mainTV?.dequeueReusableCell(withIdentifier: kDefaultCell) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = title
        cell.textLabel?.font = .boldSystemFont(ofSize: 24.0)
        cell.textLabel?.textColor = .whiteOrBlack
        return cell
    }
    
    func cellForItem(at index: IndexPath) -> UITableViewCell {
        guard let cell = mainTV?.dequeueReusableCell(withIdentifier: kDefaultCell), let trending = getPresenter(type: DiscoverViewToPresenterProtocol.self)?.trendingResults else {
            return UITableViewCell()
        }
        cell.textLabel?.text = trending[index.row - 1].name
        cell.textLabel?.font = .systemFont(ofSize: 20.0, weight: .medium)
        cell.textLabel?.textColor = .systemBlue
        cell.textLabel?.sizeToFit()
        cell.selectionStyle = .none
        return cell
    }
}
// MARK: - Presenter
extension DiscoverVC: DiscoverPresenterToViewProtocol {
    func onTrendingPeopleFetched() {
        mainTV.reloadData()
    }
    
    func onKeywordsFetched() {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self), let searchVC = searchVC, let keywords = presenter.keywords {
            searchVC.updateWithKeywords(results: keywords)
        }
    }
    
    func onGenresFiltered() {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self), let searchVC = searchVC, let genres = presenter.genres {
            searchVC.updateWithGenres(results: genres)
        }
    }
    
    func onPeopleFetched() {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self), let searchVC = searchVC, let people = presenter.people {
            searchVC.updateWithPeople(results: people)
        }
    }
}
// MARK: - UITableView
extension DiscoverVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
         case kHomeTrendingSection:
            return getPresenter(type: DiscoverViewToPresenterProtocol.self)?.trendingResults?.count ?? 0
         default:
            fatalError("Index out of bounds")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case kHomeTrendingSection:
            if indexPath.row == 0 {
                return cellForHeader(title: "Trending")
            } else {
                return cellForItem(at: indexPath)
            }
        default:
            fatalError("Index out of bounds")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case kHomeTrendingSection:
            if indexPath.row > 0 {
                // go search with ids
                getPresenter(type: DiscoverViewToPresenterProtocol.self)?.didTapOnTrendingPeople(index: indexPath.row - 1, nav: navigationController)
            }
        default:
            fatalError()
        }
    }
}
// MARK: - Search
extension DiscoverVC: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        mainTV.reloadData()
    }
}

extension DiscoverVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {return}
        searchVC?.mainTV.setContentOffset(.zero, animated: true)
//        didSearchKeyword(keyword: searchText)
        didSearchGenre(genre: searchText)
//        didSearchPeople(people: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {return}
        searchVC?.mainTV.setContentOffset(.zero, animated: true)
//        didSearchKeyword(keyword: searchText)
        didSearchGenre(genre: searchText)
//        didSearchPeople(people: searchText)
    }
}
//// MARK: - Query
//extension DiscoverVC: DiscoverQueryDelegate {
//    func didUpdateQuery() {
////        mainTV.reloadData()
//    }
//}


