//
//  DiscoverSearchTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 13/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

protocol DiscoverSearchDelegate {
    func didSearchKeyword(keyword: String)
    func didSearchGenre(genre: String)
    func didSearchPeople(people: String)
}

protocol DiscoverQueryDelegate {
    func didTapOnKeyword(keyword: Keyword)
    func didTapOnGenre(genre: GenreRLM)
    func didTapOnPeople(people: People)
}

class DiscoverSearchTVC: UITableViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var resultsTV: UITableView! {
        didSet {
            resultsTV.register(UITableViewCell.self, forCellReuseIdentifier: kDefaultCell)
            resultsTV.delegate = self
            resultsTV.dataSource = self
        }
    }
    
    var genreResults: [GenreRLM]?
    var keywordResults: [Keyword]?
    var peopleResults: [People]?
    var type: DiscoverType?
    
    var searchDelegate: DiscoverSearchDelegate?
    var queryDelegate: DiscoverQueryDelegate?
    
    // MARK: - UITVC
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        genreResults = nil
        keywordResults = nil
        peopleResults = nil
        type = nil
        searchDelegate = nil
        queryDelegate = nil
    }
    
    // MARK: - Public interface
    func configureCell(searchDelegate: DiscoverSearchDelegate, queryDelegate: DiscoverQueryDelegate, and type: DiscoverType) {
        self.searchDelegate = searchDelegate
        self.queryDelegate = queryDelegate
        self.type = type
    }
    
    func updateGenresCell(results: [GenreRLM]?) {
        self.genreResults = results
        resultsTV.reloadData()
    }
    
    func updateKeywordsCell(results: [Keyword]?) {
        self.keywordResults = results
        resultsTV.reloadData()
    }
    
    func updatePeopleCell(results: [People]?) {
        self.peopleResults = results
        resultsTV.reloadData()
    }
    
}

extension DiscoverSearchTVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let genres = genreResults {
            return (genres.isEmpty) ? 1 : genres.count
        } else if let keywords = keywordResults {
            return (keywords.isEmpty) ? 1 : keywords.count
        } else if let people = peopleResults {
            return (people.isEmpty) ? 1 : people.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForResult(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = queryDelegate else { return }
        
        if let genres = genreResults, !genres.isEmpty {
            delegate.didTapOnGenre(genre: genres[indexPath.row])
        } else if let keywords = keywordResults, !keywords.isEmpty {
            delegate.didTapOnKeyword(keyword: keywords[indexPath.row])
        } else if let people = peopleResults, !people.isEmpty {
            delegate.didTapOnPeople(people: people[indexPath.row])
        }
    }
    
    func cellForResult(at: IndexPath) -> UITableViewCell{
        
        guard let cell = resultsTV.dequeueReusableCell(withIdentifier: kDefaultCell) else {
            return UITableViewCell()
        }
        cell.textLabel?.font = .systemFont(ofSize: 14.0, weight: .light)
        
        if let genres = genreResults {
            if genres.isEmpty {
                cell.textLabel?.text = genres[at.row].name
            } else {
                cell.textLabel?.text = String(format: "search_empty_results".localized, "") // TODO lastQuery
                cell.textLabel?.textColor = kColorEmptyStateLabel
                cell.selectionStyle = .none
            }
        } else if let keywords = keywordResults {
            if keywords.isEmpty {
                cell.textLabel?.text = keywords[at.row].name
            } else {
                cell.textLabel?.text = String(format: "search_empty_results".localized, "")
                cell.textLabel?.textColor = kColorEmptyStateLabel
                cell.selectionStyle = .none
            }
        } else if let people = peopleResults {
            if people.isEmpty {
                cell.textLabel?.text = people[at.row].name
            } else {
                cell.textLabel?.text = String(format: "search_empty_results".localized, "")
                cell.textLabel?.textColor = kColorEmptyStateLabel
                cell.selectionStyle = .none
            }
        } else {
            cell.textLabel?.text = "Search something..."
            cell.textLabel?.textColor = kColorEmptyStateLabel
            cell.selectionStyle = .none
        }
        return cell
    }
}

extension DiscoverSearchTVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let type = type, let delegate = searchDelegate else {return}
        
        switch type {
        case .Keywords:
            delegate.didSearchKeyword(keyword: searchText)
        case .Genres:
            delegate.didSearchGenre(genre: searchText)
        case .People:
            delegate.didSearchPeople(people: searchText)
        }
    }
}
