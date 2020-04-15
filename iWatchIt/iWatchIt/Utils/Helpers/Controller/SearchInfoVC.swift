//
//  SearchInfoVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 15/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

protocol DiscoverQueryDelegate {
    func didTapOnKeyword(keyword: Keyword)
    func didTapOnGenre(genre: GenreRLM)
    func didTapOnPeople(people: People)
}

class SearchInfoVC: BaseVC {
    var type: DiscoverType = .Keywords
    var mediaType: MediaType = .movie
    var queryDelegate: DiscoverQueryDelegate?
    var genreResults: [GenreRLM]?
    var keywordResults: [Keyword]?
    var peopleResults: [People]?
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = "Search Keywords"
            searchBar.showsCancelButton = true
            searchBar.resignFirstResponder()
            if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = true
            }
        }
    }
    @IBOutlet weak var mainTV: UITableView! {
        didSet {
            mainTV.delegate = self
            mainTV.dataSource = self
            mainTV.register(UITableViewCell.self, forCellReuseIdentifier: kDefaultCell)
            mainTV.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func updateWithGenres(results: [GenreRLM]?) {
        self.genreResults = results
        mainTV.reloadData()
    }
    
    func updateWithKeywords(results: [Keyword]?) {
        self.keywordResults = results
        mainTV.reloadData()
    }
    
    func updateWithPeople(results: [People]?) {
        self.peopleResults = results
        mainTV.reloadData()
    }
    
    func didSearchKeyword(keyword: String) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            presenter.startFetchingKeywords(term: keyword)
        }
    }
    
    func didSearchGenre(genre: String) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            if mediaType == .movie {
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

extension SearchInfoVC: DiscoverPresenterToViewProtocol {
    func onKeywordsFetched() {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            updateWithKeywords(results: presenter.keywords)
        }
    }
    
    func onGenresFiltered(mediaType: MediaType) {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            updateWithGenres(results: presenter.genres)
        }
    }
    
    func onPeopleFetched() {
        if let presenter = getPresenter(type: DiscoverViewToPresenterProtocol.self) {
            updateWithPeople(results: presenter.people)
        }
    }
    
    
}

extension SearchInfoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch type {
        case .Keywords:
            didSearchKeyword(keyword: searchText)
        case .Genres:
            didSearchGenre(genre: searchText)
        case .People:
            didSearchPeople(people: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let genres = genreResults {
            return genres.count
        } else if let keywords = keywordResults {
            return keywords.count
        } else if let people = peopleResults {
            return people.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTV.dequeueReusableCell(withIdentifier: kDefaultCell) else {
            return UITableViewCell()
        }
        
        cell.textLabel?.font = .systemFont(ofSize: 17.0, weight: .light)
        
        if let genres = genreResults, !genres.isEmpty {
            cell.textLabel?.text = genres[indexPath.row].name
        } else if let keywords = keywordResults, !keywords.isEmpty {
            cell.textLabel?.text = keywords[indexPath.row].name
        } else if let people = peopleResults, !people.isEmpty {
            cell.textLabel?.text = people[indexPath.row].name
        }
        
        return cell
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
}
