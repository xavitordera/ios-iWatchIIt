//
//  DiscoverResultsVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 19/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverResultsVC: BaseVC, DiscoverResultsPresenterToViewProtocol {

    @IBOutlet weak var mainCV: UICollectionView! {
        didSet {
            mainCV.delegate = self
            mainCV.dataSource = self
            mainCV.allowsSelection = true
            mainCV.register(UINib(nibName: kInfiniteCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kInfiniteCarouselCVC)
            mainCV.backgroundColor = .blackOrWhite
            mainCV.contentInset = UIEdgeInsets(top: shouldShowSegmentedHeader ? 0 : 10, left: 10, bottom: 20, right: 10)
        }
    }
    
    var query: DiscoverQuery?
    var mediaType: MediaType = .movie
    var labelEmptySearch = UILabel()
    var searchTitle = ""
    
    @IBOutlet weak var heightHeaderConstraint: NSLayoutConstraint!
    
    var shouldShowSegmentedHeader: Bool = false
    private var selectedSegment = 0
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            
            if !shouldShowSegmentedHeader {
                heightHeaderConstraint.constant = 0
                segmentedControl.isHidden = true
            }
            
            segmentedControl.removeAllSegments()
            segmentedControl.insertSegment(withTitle: "discover_movies_tab".localized, at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: "discover_tv_shows_tab".localized, at: 1, animated: true)
            segmentedControl.addTarget(self, action: #selector(didChangeSegment), for: .allEvents)
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchEmptyStates()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
    }
    
    // MARK: - Auxiliar functions
    func setupNav() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = searchTitle
    }
    
    func loadData() {
        guard let presenter = getPresenter(type: DiscoverResultsViewToPresenterProtocol.self), let query = query else {
            return
        }
        mediaType = query.type
        presenter.startFetchingData(query: query, type: query.type)
    }
    
    func reloadData(isEmpty: Bool) {
        if isEmpty {
            loadSearchEmptyState()
        } else {
            hideEmptyState()
        }
        mainCV.reloadData()
    }
    
    func loadSearchEmptyState() {
        if view.subviews.contains(labelEmptySearch) {
            labelEmptySearch.removeFromSuperview()
        }
        labelEmptySearch.text = "No results found your query"
        labelEmptySearch.sizeToFit()
        labelEmptySearch.center = .init(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
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
    
    func hideEmptyState() {
        labelEmptySearch.isHidden = true
    }
    
    @objc func didChangeSegment() {
        if segmentedControl.selectedSegmentIndex != selectedSegment {
            selectedSegment = segmentedControl.selectedSegmentIndex
            didChangeType(index: selectedSegment)
        }
    }
    
    // MARK: - Presenter
    func onDataFetched(isEmpty: Bool) {
        reloadData(isEmpty: isEmpty)
    }
    
    func onShowsFetched(isEmpty: Bool) {
        reloadData(isEmpty: isEmpty)
    }
    
    func onMoviesFetched(isEmpty: Bool) {
        reloadData(isEmpty: isEmpty)
    }
}

extension DiscoverResultsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = getPresenter(type: DiscoverResultsViewToPresenterProtocol.self) else {return 0}
        
        switch mediaType {
        case .movie:
            return presenter.movieResults?.results?.count ?? 0
        default:
            return presenter.showsResults?.results?.count ?? 0
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kInfiniteCarouselCVC, for: indexPath) as? InfiniteCarouselCVC else {
            return UICollectionViewCell()
        }
        
        switch mediaType {
        case .movie:
            cell.configureCell(contentResponse: getPresenter(type: DiscoverResultsViewToPresenterProtocol.self)?.movieResults?.results?[indexPath.row])
            cell.delegate = self
        default:
            cell.configureCell(contentResponse: getPresenter(type: DiscoverResultsViewToPresenterProtocol.self)?.showsResults?.results?[indexPath.row])
            cell.delegate = self
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width / 3) - 15
        return .init(width: width, height: width * 1.5)
    }
}


extension DiscoverResultsVC: InfiniteCarouselCVCDelegate {
    func didTapCell(id: Int) {
        if let presenter = getPresenter(type: DiscoverResultsViewToPresenterProtocol.self), let nav = navigationController {
            presenter.contentSelected(navigationController: nav, for: id, and: mediaType)
        }
    }
}

extension DiscoverResultsVC {
    func didChangeType(index: Int) {
        var isEmpty = true
        
        switch index {
        case 0:
            mediaType = .movie
            isEmpty = getPresenter(type: DiscoverResultsViewToPresenterProtocol.self)?.movieResults?.results?.isEmpty ?? true
        default:
            mediaType = .show
            isEmpty = getPresenter(type: DiscoverResultsViewToPresenterProtocol.self)?.showsResults?.results?.isEmpty ?? true
        }
        
        getPresenter(type: DiscoverResultsViewToPresenterProtocol.self)?.didChangeType(type: mediaType)
        reloadData(isEmpty: isEmpty)
    }
}

extension DiscoverResultsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == scrollView.contentSize.height {
            
        }
    }
}
