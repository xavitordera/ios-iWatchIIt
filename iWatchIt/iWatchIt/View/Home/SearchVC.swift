//
//  SearchVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class SearchVC: BaseVC, SearchPresenterToViewProtocol, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource {
        
    var type: MediaType = .movie
    var mainCV: UICollectionView?
    var sections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Presenter
    
    func onDataFetched() {
        mainCV?.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let presenter = getPresenter() else {
            return
        }
        presenter.startFetchingData(query: searchText, type: type)
    }
    
    // MARK: - Auxiliar functions
    func getPresenter() -> SearchViewToPresenterProtocol? {
        guard let presenter = self.presenter as? SearchViewToPresenterProtocol else {
            showError(message: "app_error_generic".localized)
            return nil
        }
        return presenter
    }
    
    // MARK: - UICollectionView
    func setupTV() {
        mainCV = UICollectionView(frame: self.view.frame)
        mainCV?.delegate = self
        mainCV?.dataSource = self
        mainCV?.allowsSelection = true
        mainCV?.register(UINib(nibName: kInfiniteCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kInfiniteCarouselCVC)
        mainCV?.register(UINib(nibName: kSectionHeader, bundle: .main), forSupplementaryViewOfKind: kSectionHeader, withReuseIdentifier: kSectionHeader)
        mainCV?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        view = (mainCV!)
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
        return UICollectionViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPresenter()?.search?.results?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: .init(x: 0, y: 0, width: mainCV?.frame.width ?? 0, height: 45))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results"
    }
}
