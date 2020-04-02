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
    var emptySearchTV: UITableView?
    var sections: [String] = []
    var isEmpty = true
    var searchBar: UISearchBar?
    var labelEmpty = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyState()
        setupCV()
        setupTV()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let searchBarText = self.searchBar?.text else {
            showEmptyTV()
            return
        }
        isEmpty = searchBarText.isEmpty
        isEmpty ? showEmptyTV() : showMainCV()
    }
    
    // MARK: - Presenter
    
    func onDataFetched(isEmpty: Bool) {
        reloadData(isEmpty: isEmpty)
        if !isEmpty {
            mainCV?.scrollToItem(at: .init(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func reloadData(isEmpty: Bool) {
        mainCV?.reloadData()
        if isEmpty {
            loadSearchEmptyState()
        } else {
            labelEmpty.isHidden = true
        }
        emptySearchTV?.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let presenter = getPresenter() else {return}
        
        if searchText.isEmpty {
            showEmptyTV()
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
    
    func showEmptyTV() {
        loadEmptyState()
        view = emptySearchTV
    }
    
    func showMainCV() {
        view = mainCV
    }
    
    func loadEmptyState() {
        guard let presenter = getPresenter() else {
            return
        }
        presenter.startFetchingHistory(type: type)
    }
    
    func loadSearchEmptyState() {
        if view.subviews.contains(labelEmpty) {
            labelEmpty.removeFromSuperview()
        }
        labelEmpty.text = String(format: "search_header_recently_seen".localized, getPresenter()?.lastQuery ?? "")
        labelEmpty.sizeToFit()
        labelEmpty.center = view.center
        labelEmpty.isHidden = false
        view.addSubview(labelEmpty)
    }

    func setupEmptyState() {
        labelEmpty.font = .systemFont(ofSize: 20.0, weight: .light)
        labelEmpty.textColor = kColorEmptyStateLabel
        labelEmpty.isHidden = true
        view.addSubview(labelEmpty)
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
        mainCV?.allowsSelection = false
        mainCV?.register(UINib(nibName: kInfiniteCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kInfiniteCarouselCVC)
        mainCV?.backgroundView?.alpha = 0.4
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let presenter = getPresenter(), let contentSelectedId = presenter.search?.results?[indexPath.row].id else {
            return
        }
        presenter.showDetailController(navigationController: self.navigationController!, for: contentSelectedId)
    }
    
    // MARK: - UITableView
    
    func setupTV() {
        debugPrint(view.frame)
        emptySearchTV = UITableView(frame: view.frame)
        emptySearchTV?.delegate = self
        emptySearchTV?.dataSource = self
        emptySearchTV?.tableFooterView = UIView()
        emptySearchTV?.allowsSelection = true
        emptySearchTV?.register(UITableViewCell.self, forCellReuseIdentifier: kDefaultCell)
        emptySearchTV?.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        emptySearchTV?.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        emptySearchTV?.clipsToBounds = true
        emptySearchTV?.alwaysBounceVertical = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPresenter()?.recentlySeen?.count ?? 0
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
       guard let presenter = getPresenter(), let contentSelectedId = presenter.recentlySeen?[indexPath.row].id else {
            return
        }
        presenter.showDetailController(navigationController: self.navigationController!, for: contentSelectedId)
    }
    
    func cellForItem(at index: IndexPath) -> UITableViewCell {
        guard let cell = emptySearchTV?.dequeueReusableCell(withIdentifier: kDefaultCell), let results = getPresenter()?.recentlySeen else {
            return UITableViewCell()
        }
        cell.textLabel?.text = results[index.row].title
        cell.textLabel?.font = .systemFont(ofSize: 20.0, weight: .medium)
        cell.textLabel?.textColor = .systemBlue
        cell.textLabel?.sizeToFit()
        cell.selectionStyle = .none
        return cell
    }
 
    func cellForHeader() -> UITableViewCell {
        guard let cell = emptySearchTV?.dequeueReusableCell(withIdentifier: kDefaultCell) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "Recently seen"
        cell.textLabel?.font = .boldSystemFont(ofSize: 24.0)
        cell.textLabel?.textColor = .whiteOrBlack
        return cell
    }
}
