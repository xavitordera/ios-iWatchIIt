//
//  SearchInfoVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 15/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

protocol SearchInfoVCDelegate {
    func didTapOnGenre(genre: TypedSearchResult)
    func didTapOnPeople(people: TypedSearchResult)
    func didTapOnKeyword(keyword: TypedSearchResult)
}

class SearchInfoVC: BaseVC {
    var type: DiscoverType = .Keywords
    var mediaType: MediaType = .movie
    var queryDelegate: DiscoverQueryDelegate?
    var genreResults: [TypedSearchResult]?
    var keywordResults: [TypedSearchResult]?
    var peopleResults: [TypedSearchResult]?
    var labelEmptySearch = UILabel()
    var delegate: SearchInfoVCDelegate?
    
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
            mainTV.allowsSelection = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
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
    
    func updateWithGenres(results: [TypedSearchResult]?) {
        self.genreResults = results
        loadSections()
        mainTV.reloadData()
        if let genres = genreResults, !genres.isEmpty {
            labelEmptySearch.isHidden = true
        }
    }
    
    func updateWithKeywords(results: [TypedSearchResult]?) {
        self.keywordResults = results
        loadSections()
        mainTV.reloadData()
        if let keywords = keywordResults, !keywords.isEmpty {
            labelEmptySearch.isHidden = true
        }
    }
    
    func updateWithPeople(results: [TypedSearchResult]?) {
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
        if let keywords = keywordResults, !keywords.isEmpty {
            cell.configureCell(keyword: keywords[indexPath.row], genre: nil)
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
            }
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
}

extension SearchInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case kSectionDiscoverGenre:
            return genreResults?.count ?? 0
        case kSectionDiscoverPeople:
            return peopleResults?.count ?? 0
        case kSectionDiscoverKeywords:
            return keywordResults?.count ?? 0
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
            delegate?.didTapOnGenre(genre: genreResults![indexPath.row])
        case kSectionDiscoverPeople:
            delegate?.didTapOnPeople(people: peopleResults![indexPath.row])
        case kSectionDiscoverKeywords:
            delegate?.didTapOnKeyword(keyword: keywordResults![indexPath.row])
        default:
            fatalError("Index out of bounds")
        }
    }
}
