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
        }
    }
    
    func updateWithKeywords(results: [Keyword]?) {
        self.keywordResults = results
        loadSections()
        mainTV.reloadData()
        if let keywords = keywordResults, !keywords.isEmpty {
            labelEmptySearch.isHidden = true
        }
    }
    
    func updateWithPeople(results: [People]?) {
        self.peopleResults = results
        loadSections()
        mainTV.reloadData()
        if let people = peopleResults, !people.isEmpty {
            labelEmptySearch.isHidden = true
        }
    }
    
    func cellForKeyword(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTV.dequeueReusableCell(withIdentifier: kDiscoverSearchTVC) as? DiscoverSearchTVC else {
            return UITableViewCell()
        }
        if let keywords = keywordResults {
            !keywords.isEmpty ? cell.configureCell(keyword: keywords[indexPath.row], genre: nil) : cell.configureEmpty(text: "No keywords found")
        }
        return cell
    }
    
    func cellForGenre(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTV.dequeueReusableCell(withIdentifier: kDiscoverSearchTVC) as? DiscoverSearchTVC else {
            return UITableViewCell()
        }
        if let genres = genreResults {
            if !genres.isEmpty {
                cell.configureCell(keyword: nil, genre: genres[indexPath.row])
            } else {
                cell.configureEmpty(text: "No genres found")
            }
        }
        return cell
    }
    
    func cellForPeople(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTV.dequeueReusableCell(withIdentifier: kDiscoverPeopleTVC) as? DiscoverPeopleTVC else {
            return UITableViewCell()
        }
        if let people = peopleResults {
            !people.isEmpty ? cell.configureCell(people: people[indexPath.row]) : cell.configureEmpty(text: "No people found")
        }
        return cell
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
            if let genres = genreResults {
                return genres.count > 0 ? genres.count : 1
            }
        case kSectionDiscoverPeople:
            if let people = peopleResults {
                return people.count > 0 ? people.count : 1
            }
        case kSectionDiscoverKeywords:
            if let keywords = keywordResults {
                return keywords.count > 0 ? keywords.count : 1
            }
        default:
            fatalError("Index out of bounds")
        }
        
        return 0
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
//        mainTV.reloadData()
    }
}
