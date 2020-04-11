//
//  SearchVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class SearchVC: BaseVC, SearchPresenterToViewProtocol, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    var type: MediaType = .movie
    var mainCV: UICollectionView?
    var firstStateTV: UITableView?
    var sections: [String] = []
    var isEmpty = true
    var searchBar: UISearchBar?
    var labelEmptySearch = UILabel()
    var nav: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchEmptyStates()
        setupCV()
        setupTV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let searchBarText = self.searchBar?.text else {
            showFirstStateTV()
            return
        }
        isEmpty = searchBarText.isEmpty
        isEmpty ? showFirstStateTV() : showMainCV()
    }
    
    // MARK: - Presenter
    
    func onDataFetched(isEmpty: Bool) {
        reloadWithSearchData(isEmpty: isEmpty)
        if !isEmpty {
            mainCV?.scrollToItem(at: .init(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func onRecentlySeenFetched(isEmpty: Bool) {
        reloadWithSearchHistory(isEmpty: isEmpty)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let presenter = getPresenter() else {return}
        
        if searchText.isEmpty {
            showFirstStateTV()
        } else {
            showMainCV()
            presenter.startFetchingData(query: searchText, type: type)
        }
    }
    
    // MARK: - Auxiliar functions
    
    func getPresenter() -> SearchViewToPresenterProtocol? {
        guard let presenter = self.presenter as? SearchViewToPresenterProtocol else {
            showError(message: "app_error_generic".localized)
            return nil
        }
        return presenter
    }
    
    func showFirstStateTV() {
        loadFirstState()
        view = firstStateTV
    }
    
    func showMainCV() {
        view = mainCV
    }
    
    func reloadWithSearchData(isEmpty: Bool) {
        mainCV?.reloadData()
        if isEmpty {
            loadSearchEmptyState(isHistory: false)
        } else {
            labelEmptySearch.isHidden = true
        }
    }
    
    func reloadWithSearchHistory(isEmpty: Bool) {
        firstStateTV?.reloadData()
        if isEmpty {
            loadSearchEmptyState(isHistory: true)
        } else {
            labelEmptySearch.isHidden = true
        }
    }
    
    func loadFirstState() {
        guard let presenter = getPresenter() else {
            return
        }
        presenter.startFetchingHistory(type: type)
    }
    
    func loadSearchEmptyState(isHistory: Bool) {
        if view.subviews.contains(labelEmptySearch) {
            labelEmptySearch.removeFromSuperview()
        }
        labelEmptySearch.text = isHistory ? "search_empty_history".localized : String(format: "search_empty_results".localized, getPresenter()?.lastQuery ?? "")
        labelEmptySearch.sizeToFit()
        labelEmptySearch.center = .init(x: UIScreen.main.bounds.width/2 - 10, y: UIScreen.main.bounds.height/2 - topbarHeight - 75)
        labelEmptySearch.isHidden = false
        view.addSubview(labelEmptySearch)
    }
    
    func setupSearchEmptyStates() {
        labelEmptySearch.font = .systemFont(ofSize: 20.0, weight: .light)
        labelEmptySearch.textColor = kColorEmptyStateLabel
        labelEmptySearch.isHidden = true
        labelEmptySearch.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 10
        labelEmptySearch.numberOfLines = 0
        labelEmptySearch.textAlignment = .center
        view.addSubview(labelEmptySearch)
    }
    // MARK: - UICollectionView
    
    func setupCV() {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.size.width / 3) - 15
        layout.itemSize = .init(width: width, height: width * 1.5)
        layout.scrollDirection = .vertical
        mainCV = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        mainCV?.delegate = self
        mainCV?.dataSource = self
        mainCV?.allowsSelection = true
        mainCV?.register(UINib(nibName: kInfiniteCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kInfiniteCarouselCVC)
        mainCV?.backgroundColor = .blackOrWhite
        if let bottomInset = UserDefaults.standard.object(forKey: "keyboardHeight") as? CGFloat {
            mainCV?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: bottomInset, right: 10)
        } else {
            mainCV?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getPresenter()?.search?.results?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kInfiniteCarouselCVC, for: indexPath) as? InfiniteCarouselCVC else {
            return UICollectionViewCell()
        }
        cell.configureCell(contentResponse: getPresenter()?.search?.results?[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableView
    
    func setupTV() {
        firstStateTV = UITableView(frame: view.frame)
        firstStateTV?.delegate = self
        firstStateTV?.dataSource = self
        firstStateTV?.tableFooterView = UIView()
        firstStateTV?.allowsSelection = true
        firstStateTV?.register(UITableViewCell.self, forCellReuseIdentifier: kDefaultCell)
        firstStateTV?.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        firstStateTV?.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        firstStateTV?.clipsToBounds = true
        firstStateTV?.alwaysBounceVertical = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = (getPresenter()?.recentlySeen?.count) {
            return count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellForHeader()
        default:
            return cellForItem(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = getPresenter(), let recSee = presenter.recentlySeen, indexPath.row > 0 && indexPath.row - 1 < recSee.count else {
            return
        }
        let contentSelectedId = recSee[indexPath.row - 1].id
        presenter.contentSelected(navigationController: nav!, for: contentSelectedId, and: type)
    }
    
    func cellForItem(at index: IndexPath) -> UITableViewCell {
        guard let cell = firstStateTV?.dequeueReusableCell(withIdentifier: kDefaultCell), let results = getPresenter()?.recentlySeen else {
            return UITableViewCell()
        }
        cell.textLabel?.text = results[index.row - 1].title
        cell.textLabel?.font = .systemFont(ofSize: 20.0, weight: .medium)
        cell.textLabel?.textColor = .systemBlue
        cell.textLabel?.sizeToFit()
        cell.selectionStyle = .none
        return cell
    }
    
    func cellForHeader() -> UITableViewCell {
        guard let cell = firstStateTV?.dequeueReusableCell(withIdentifier: kDefaultCell) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "Recently seen"
        cell.textLabel?.font = .boldSystemFont(ofSize: 24.0)
        cell.textLabel?.textColor = .whiteOrBlack
        return cell
    }
}

extension SearchVC: InfiniteCarouselCVCDelegate {
    func didTapCell(id: Int) {
        if let presenter = getPresenter() {
            presenter.contentSelected(navigationController: self.nav!, for: id, and: self.type)
        }
    }
}
