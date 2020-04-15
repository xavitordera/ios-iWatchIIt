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
    
    
    @IBOutlet weak var mainTV: UITableView! {
        didSet {
            mainTV.separatorStyle = .none
            mainTV.register(UINib(nibName: kDiscoverHeaderTHV, bundle: .main), forHeaderFooterViewReuseIdentifier: kDiscoverHeaderTHV)
            mainTV.register(UINib(nibName: kDiscoverSearchTVC, bundle: .main), forCellReuseIdentifier: kDiscoverSearchTVC)
            mainTV.register(UITableViewCell.self, forCellReuseIdentifier: "default")
            mainTV.delegate = self
            mainTV.dataSource = self
            mainTV.bounces = false
            mainTV.allowsSelection = false
        }
    }
    
    @IBOutlet weak var segMediaType: UISegmentedControl! {
        didSet {
            segMediaType.setTitle("discover_tv_shows_tab".localized, forSegmentAt: SegmentIndexes.shows.rawValue)
            segMediaType.setTitle("discover_movies_tab".localized, forSegmentAt: SegmentIndexes.movies.rawValue)
        }
    }
    
    var searchButton: UIButton?
    // MARK: - UIVienController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Auxiliar functions
    
    func setupNav() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "discover_title".localized
    }
    
    func setupSearchButton() {
        searchButton = UIButton(frame: .init(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height - 160, width: 150, height: 40))
        searchButton?.backgroundColor = .darkGray
        searchButton?.setTitleColor(.black, for: .normal)
        searchButton?.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .regular)
        searchButton?.setTitle("discover_search".localized, for: .normal)
        searchButton?.setImage(kTabDiscoverImg, for: .normal)
        searchButton?.layer.cornerRadius = 14
        searchButton?.layer.borderWidth = 1
        searchButton?.layer.borderColor = UIColor.black.cgColor
        searchButton?.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        searchButton?.addTarget(self, action: #selector(searchTap), for: .touchUpInside)
        
        view.addSubview(searchButton!)
    }
    
    func setup() {
        setupNav()
        setupSearchButton()
        setupSections()
        loadData()
    }
    
    func setupSections() {
        sections = [
            kSectionDiscoverKeywords,
            kSectionDiscoverGenre,
            kSectionDiscoverPeople
                    ]
    }
    
    func loadData() {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.startFetchingGenres(mediaType: .movie)
            presenter.startFetchingGenres(mediaType: .show)
        }
    }
    
    // MARK: - Actions
    
    @objc func searchTap() {
        
    }
    
    // MARK: UITableview auxiliar functions
    
    func headerForKeywords() -> UITableViewHeaderFooterView  {
        guard let header = mainTV.dequeueReusableHeaderFooterView(withIdentifier: kDiscoverHeaderTHV) as? DiscoverHeaderTVC else { return UITableViewHeaderFooterView() }
        header.configureCell(title: "Keywords", delegate: self, type: .Keywords)
        return header
    }
    
    func headerForGenres() -> UITableViewHeaderFooterView  {
        guard let header = mainTV.dequeueReusableHeaderFooterView(withIdentifier: kDiscoverHeaderTHV) as? DiscoverHeaderTVC else { return UITableViewHeaderFooterView() }
        header.configureCell(title: "Genres", delegate: self, type: .Genres)
        return header
    }
    
    func headerForPeople() -> UITableViewHeaderFooterView  {
        guard let header = mainTV.dequeueReusableHeaderFooterView(withIdentifier: kDiscoverHeaderTHV) as? DiscoverHeaderTVC else { return UITableViewHeaderFooterView() }
        header.configureCell(title: "People", delegate: self, type: .People)
        return header
    }
    
    func cellForSection(type: DiscoverType, indexPath: IndexPath) -> UITableViewCell{
        guard let cell = mainTV.dequeueReusableCell(withIdentifier: kDiscoverSearchTVC, for: indexPath) as? DiscoverSearchTVC else {
            return UITableViewCell()
        }
        cell.configureCell(searchDelegate: self, queryDelegate: self, and: type)
        return cell
    }
}

extension DiscoverVC: DiscoverPresenterToViewProtocol {
    
    func onKeywordsFetched() {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self), let index = sections.firstIndex(of: kSectionDiscoverKeywords) {
            if let cell = mainTV.cellForRow(at: .init(row: 0, section: index)) as? DiscoverSearchTVC {
                cell.updateKeywordsCell(results: presenter.keywords)
                mainTV.reloadData()
            }
        }
    }
    
    func onGenresFiltered(mediaType: MediaType) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self), let index = sections.firstIndex(of: kSectionDiscoverGenre) {
            if let cell = mainTV.cellForRow(at: .init(row: 0, section: index)) as? DiscoverSearchTVC {
                cell.updateGenresCell(results: presenter.genres)
                mainTV.reloadData()
            }
        }
    }
    
    func onPeopleFetched() {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self), let index = sections.firstIndex(of: kSectionDiscoverPeople) {
            if let cell = mainTV.cellForRow(at: .init(row: 0, section: index)) as? DiscoverSearchTVC {
                cell.updatePeopleCell(results: presenter.people)
                mainTV.reloadData()
            }
        }
    }
}

extension DiscoverVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case kSectionDiscoverKeywords:
            return cellForSection(type: .Keywords, indexPath: indexPath)
        case kSectionDiscoverGenre:
            return cellForSection(type: .Genres, indexPath: indexPath)
        case kSectionDiscoverPeople:
            return cellForSection(type: .People, indexPath: indexPath)
        default:
            fatalError("Index out of bounds")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case kSectionDiscoverKeywords:
            return headerForKeywords()
        case kSectionDiscoverGenre:
            return headerForGenres()
        case kSectionDiscoverPeople:
            return headerForPeople()
        default:
            return UITableViewHeaderFooterView()
        }
    }
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeightDiscoverSections
    }
}

extension DiscoverVC: DiscoverHeaderDelegate {
    func didExpand(type: DiscoverType) {
        var section: Int = 0
        switch type {
        case .Keywords:
            section = sections.firstIndex(of: kSectionDiscoverKeywords) ?? 0
        case .Genres:
            section = sections.firstIndex(of: kSectionDiscoverGenre) ?? 0
        case .People:
            section = sections.firstIndex(of: kSectionDiscoverPeople) ?? 0
        }
        mainTV.beginUpdates()
        mainTV.insertRows(at: [.init(row: 0, section: section)], with: .automatic)
        mainTV.endUpdates()
    }
    
    func didCollapse(type: DiscoverType) {
        var section: Int = 0
        switch type {
        case .Keywords:
            section = sections.firstIndex(of: kSectionDiscoverKeywords) ?? 0
        case .Genres:
            section = sections.firstIndex(of: kSectionDiscoverGenre) ?? 0
        case .People:
            section = sections.firstIndex(of: kSectionDiscoverPeople) ?? 0
        }
        mainTV.beginUpdates()
        mainTV.deleteRows(at: [.init(row: 0, section: section)], with: .automatic)
        mainTV.endUpdates()
    }
}

extension DiscoverVC: DiscoverQueryDelegate {
    func didTapOnKeyword(keyword: Keyword) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.didSelectKeyword(keyword: keyword)
        }
    }
    
    func didTapOnGenre(genre: GenreRLM) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.didSelectGenre(genre: genre)
        }
    }
    
    func didTapOnPeople(people: People) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.didSelectPeople(people: people)
        }
    }
}

extension DiscoverVC: DiscoverSearchDelegate {
    func didSearchKeyword(keyword: String) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.startFetchingKeywords(term: keyword)
        }
    }
    
    func didSearchGenre(genre: String) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            if segMediaType.selectedSegmentIndex == SegmentIndexes.movies.rawValue {
                presenter.startFilteringGenres(term: genre, mediaType: .movie)
            } else {
                presenter.startFilteringGenres(term: genre, mediaType: .show)
            }
        }
    }
    
    func didSearchPeople(people: String) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.startFetchingPeople(term: people)
        }
    }
}

