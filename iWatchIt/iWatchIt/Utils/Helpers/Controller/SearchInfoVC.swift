//
//  SearchInfoVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 15/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit


class SearchInfoVC: BaseVC {
    var type: DiscoverType = .Keywords
    var mediaType: MediaType = .movie
    var queryDelegate: DiscoverQueryDelegate?
    var genreResults: [GenreRLM]?
    var keywordResults: [Keyword]?
    var peopleResults: [People]?
    var labelEmptySearch = UILabel()
    
    var sections: [String] = []
    
    @IBOutlet weak var mainTV: UITableView! {
        didSet {
            mainTV.delegate = self
            mainTV.dataSource = self
            mainTV.register(UINib(nibName: kDiscoverSearchTVC, bundle: .main), forCellReuseIdentifier: kDiscoverSearchTVC)
            mainTV.register(UINib(nibName: kDiscoverPeopleTVC, bundle: .main), forCellReuseIdentifier: kDiscoverPeopleTVC)
            mainTV.register(UINib(nibName: kDiscoverHeaderTHV, bundle: .main), forHeaderFooterViewReuseIdentifier: kDiscoverHeaderTHV)
            mainTV.tableFooterView = UIView()
            mainTV.separatorStyle = .singleLine
            
            if let bottomInset = UserDefaults.standard.object(forKey: "keyboardHeight") as? CGFloat {
                mainTV?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
            } else {
                mainTV?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            }
            mainTV.allowsSelection = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchEmptyStates()
        DiscoverQuery.shared.addDelegate(delegate: self)
    }
    
    func loadSections() {
        sections = []
        if let _ = genreResults {
            sections.append(kSectionDiscoverGenre)
        }
        
        if let _ = peopleResults {
            sections.append(kSectionDiscoverPeople)
        }
        
        if let _ = keywordResults {
            sections.append(kSectionDiscoverKeywords)
        }
    }
    
    func updateWithGenres(results: [GenreRLM]?) {
        self.genreResults = results
        loadSections()
        mainTV.reloadData()
        if let genres = genreResults, !genres.isEmpty {
            labelEmptySearch.isHidden = true
        } else {
            loadSearchEmptyState(type: .Genres)
        }
    }
    
    func updateWithKeywords(results: [Keyword]?) {
        self.keywordResults = results
        loadSections()
        mainTV.reloadData()
        if let keywords = keywordResults, !keywords.isEmpty {
            labelEmptySearch.isHidden = true
        } else {
            loadSearchEmptyState(type: .Keywords)
        }
    }
    
    func updateWithPeople(results: [People]?) {
        self.peopleResults = results
        loadSections()
        mainTV.reloadData()
        if let people = peopleResults, !people.isEmpty {
            labelEmptySearch.isHidden = true
        } else {
            loadSearchEmptyState(type: .People)
        }
    }
    
    func cellForKeyword(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTV.dequeueReusableCell(withIdentifier: kDiscoverSearchTVC) as? DiscoverSearchTVC else {
            return UITableViewCell()
        }
        if let keywords = keywordResults, !keywords.isEmpty {
            cell.configureCell(keyword: keywords[indexPath.row], genre: nil)
        }
        return cell
    }
    
    func cellForGenre(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTV.dequeueReusableCell(withIdentifier: kDiscoverSearchTVC) as? DiscoverSearchTVC else {
            return UITableViewCell()
        }
        if let genres = genreResults, !genres.isEmpty {
            cell.configureCell(keyword: nil, genre: genres[indexPath.row])
        }
        return cell
    }
    
    func cellForPeople(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTV.dequeueReusableCell(withIdentifier: kDiscoverPeopleTVC) as? DiscoverPeopleTVC else {
            return UITableViewCell()
        }
        if let people = peopleResults, !people.isEmpty {
            cell.configureCell(people: people[indexPath.row])
        }
        return cell
    }
    
    func loadSearchEmptyState(type: DiscoverType) {
        if view.subviews.contains(labelEmptySearch) {
            labelEmptySearch.removeFromSuperview()
        }
        labelEmptySearch.sizeToFit()
        labelEmptySearch.center = .init(x: UIScreen.main.bounds.width/2 - 10, y: UIScreen.main.bounds.height/2 - topbarHeight - 75)
        labelEmptySearch.isHidden = false
        view.addSubview(labelEmptySearch)
        
        switch type {
        case .Keywords:
            labelEmptySearch.text = "No keywords found"
        case .Genres:
            labelEmptySearch.text = "No genres found"
        case .People:
            labelEmptySearch.text = "No people found"
        }
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
    
    func headerForKeywords() -> UITableViewHeaderFooterView  {
        guard let header = mainTV.dequeueReusableHeaderFooterView(withIdentifier: kDiscoverHeaderTHV) as? DiscoverHeaderTVC else { return UITableViewHeaderFooterView() }
        header.configureCell(title: "Keywords")
        return header
    }
    
    func headerForGenres() -> UITableViewHeaderFooterView  {
        guard let header = mainTV.dequeueReusableHeaderFooterView(withIdentifier: kDiscoverHeaderTHV) as? DiscoverHeaderTVC else { return UITableViewHeaderFooterView() }
        header.configureCell(title: "Genres")
        return header
    }
    
    func headerForPeople() -> UITableViewHeaderFooterView  {
        guard let header = mainTV.dequeueReusableHeaderFooterView(withIdentifier: kDiscoverHeaderTHV) as? DiscoverHeaderTVC else { return UITableViewHeaderFooterView() }
        header.configureCell(title: "People")
        return header
    }
}

extension SearchInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case kSectionDiscoverGenre:
            return UITableView.automaticDimension
        case kSectionDiscoverPeople:
            return 105
        case kSectionDiscoverKeywords:
            return UITableView.automaticDimension
        default:
            fatalError("Index out of bounds")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case kSectionDiscoverGenre:
            return genreResults?.count ?? 0
        case kSectionDiscoverPeople:
            return peopleResults?.count ?? 0
        case kSectionDiscoverKeywords:
            return genreResults?.count ?? 0
        default:
            fatalError("Index out of bounds")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case kSectionDiscoverGenre:
            return cellForGenre(indexPath: indexPath)
        case kSectionDiscoverPeople:
            return cellForPeople(indexPath: indexPath)
        case kSectionDiscoverKeywords:
            return cellForKeyword(indexPath: indexPath)
        default:
            fatalError("Index out of bounds")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case kSectionDiscoverGenre:
            DiscoverQuery.shared.addOrRemoveGenre(genre: genreResults![indexPath.row])
        case kSectionDiscoverPeople:
            DiscoverQuery.shared.addOrRemovePeople(people: peopleResults![indexPath.row])
        case kSectionDiscoverKeywords:
            DiscoverQuery.shared.addOrRemoveKeyword(keyword: keywordResults![indexPath.row])
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
}

extension SearchInfoVC: DiscoverQueryDelegate {
    func didUpdateQuery() {
        mainTV.reloadData()
    }
}
