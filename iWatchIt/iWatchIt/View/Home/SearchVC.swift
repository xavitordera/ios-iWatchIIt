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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func onDataFetched() {
        mainCV?.reloadData()
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
        view = emptySearchTV
    }
    
    func showMainCV() {
        view = mainCV
    }
    
    // MARK: - UICollectionView
    
    func setupCV() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 150)
        layout.scrollDirection = .vertical
        mainCV = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        mainCV?.delegate = self
        mainCV?.dataSource = self
        mainCV?.allowsSelection = false
        mainCV?.register(UINib(nibName: kInfiniteCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kInfiniteCarouselCVC)
        mainCV?.register(UINib(nibName: kSectionHeader, bundle: .main), forSupplementaryViewOfKind: kSectionHeader, withReuseIdentifier: kSectionHeader)
        mainCV?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getPresenter()?.search?.results?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kSectionHeader, for: indexPath) as? SectionHeader {
            sectionHeader.configureHeader(title: "Results")
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kInfiniteCarouselCVC, for: indexPath) as? InfiniteCarouselCVC else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let presenter = getPresenter(), let contentSelected = presenter.search?.results?[indexPath.row] else {
            return
        }
        presenter.showDetailController(navigationController: self.navigationController!, for: contentSelected.id)
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
        emptySearchTV?.contentInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
        // go detail
//        guard let presenter = getPresenter(), let contentSelected = presenter.recentlySearched?[indexPath.row] else {
//            return
//        }
//        debugPrint("tap on cell with content id -> \(contentSelected.id)")
    }
    
    func cellForItem(at index: IndexPath) -> UITableViewCell {
        guard let cell = emptySearchTV?.dequeueReusableCell(withIdentifier: kDefaultCell), let results = getPresenter()?.recentlySeen else {
            return UITableViewCell()
        }
        cell.textLabel?.text = results[index.row].title
        cell.textLabel?.font = .systemFont(ofSize: 21.0, weight: .medium)
        cell.textLabel?.textColor = .systemBlue
        return cell
    }
 
    func cellForHeader() -> UITableViewCell {
        guard let cell = emptySearchTV?.dequeueReusableCell(withIdentifier: kDefaultCell) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "Recently seen"
        cell.textLabel?.font = .boldSystemFont(ofSize: 27.0)
        cell.textLabel?.textColor = .whiteOrBlack
        return cell
    }
}
