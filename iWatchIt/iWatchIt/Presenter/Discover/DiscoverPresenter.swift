//
//  DiscoverPresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverPresenter: BasePresenter {
    var query: DiscoverQuery?
    var keywords: [TypedSearchResult]?
    var genres: [TypedSearchResult]?
    var people: [TypedSearchResult]?
    var showsGenres: GenresRLM?
    var moviesGenres: GenresRLM?
    var wholeGenres: [TypedSearchResult] = []
    var trendingResults: [TypedSearchResult]?
    
    var lastQuery: String = ""
    
    private func filterGenre(term: String, type: MediaType) -> [GenreRLM] {
        
        let mainGenre = type == .movie ? moviesGenres : showsGenres
        guard let unwrappedMainGenre = mainGenre else { return [] }
        
        let filtered = unwrappedMainGenre.genres.filter {
            $0.name.lowercased().contains(term.lowercased())
        }
        
        return Array(filtered)
    }
    
    private func initGenres() {
        guard let movieGenres = moviesGenres, let showsGenres = showsGenres else { return }
        for genre in movieGenres.genres {
            let aux = TypedSearchResult.createFromGenre(genre: genre, withMediaType: .movie)
            wholeGenres.append(aux)
        }
        
        for genre in showsGenres.genres {
            let aux = TypedSearchResult.createFromGenre(genre: genre, withMediaType: .show)
            wholeGenres.append(aux)
        }
    }
    
    private func filterGenre(term: String) -> [TypedSearchResult] {
        
        if wholeGenres.isEmpty {
            initGenres()
        }
        
        let filtered = wholeGenres.filter {
            ($0.name?.lowercased().contains(term.lowercased()) ?? false)
        }
        
        return filtered
    }
}

extension DiscoverPresenter: DiscoverViewToPresenterProtocol {
    func didTapOnGenre(genre: TypedSearchResult, nav: UINavigationController?) {
        query = DiscoverQuery()
        query?.addOrRemoveGenre(genre: genre)
        query?.type = genre.mediaType ?? .movie
        query?.title = genre.name
        if let router = router as? DiscoverPresenterToRouterProtocol, let query = query, let nav = nav {
            router.pushToResultsScreen(navigationController: nav, for: query, mediaType: .movie, shouldShowHeader: false)
        }
    }
    
    func didTapOnPeople(people: TypedSearchResult, nav: UINavigationController?) {
        query = DiscoverQuery()
        query?.addOrRemovePeople(people: people)
        query?.type = people.mediaType ?? .movie
        query?.title = people.name
        if let router = router as? DiscoverPresenterToRouterProtocol, let query = query, let nav = nav {
            router.pushToResultsScreen(navigationController: nav, for: query, mediaType: .movie, shouldShowHeader: false)
        }
    }
    
    func didTapOnKeyword(keyword: TypedSearchResult, nav: UINavigationController?) {
        query = DiscoverQuery()
        query?.addOrRemoveKeyword(keyword: keyword)
        query?.title = keyword.name
        if let router = router as? DiscoverPresenterToRouterProtocol, let query = query, let nav = nav {
            router.pushToResultsScreen(navigationController: nav, for: query, mediaType: .movie, shouldShowHeader: true)
        }
    }
    
    func startDiscovering(navigationController: UINavigationController, query: DiscoverQuery, mediaType: MediaType) {
//        if let router = router as? DiscoverPresenterToRouterProtocol {
//            router.pushToResultsScreen(navigationController: navigationController, for: query, mediaType: mediaType, shouldShowHeader: )
//        }
    }
    
    func startFetchingKeywords(term: String) {
        guard let interactor = self.interactor as? DiscoverPresenterToInteractorProtocol else { return  }
        interactor.fetchKeywords(term: term)
    }

    func startFetchingGenres(mediaType: MediaType) {
        guard let interactor = self.interactor as? DiscoverPresenterToInteractorProtocol else { return  }
        interactor.fetchGenres(mediaType: mediaType)
    }
    
    func startFilteringGenres(term: String, mediaType: MediaType) {
//        let results = filterGenre(term: term, type: mediaType)
//        self.genres = results
//        if let view = getView(type: DiscoverPresenterToViewProtocol.self) {
//            view.onGenresFiltered(mediaType: mediaType)
//        }
    }
    
    func startFilteringGenres(term: String) {
        lastQuery = term
        startFetchingPeople(term: lastQuery)
        let results = filterGenre(term: term)
        self.genres = Array(results.prefix(5))
        if let view = getView(type: DiscoverPresenterToViewProtocol.self) {
            view.onGenresFiltered()
        }
    }
    
    func startFetchingPeople(term: String) {
        guard let interactor = self.interactor as? DiscoverPresenterToInteractorProtocol else { return }
        interactor.fetchPeople(term: term)
    }
    
    func startFetchingTrendingPeople() {
        guard let interactor = self.interactor as? DiscoverPresenterToInteractorProtocol else { return }
        interactor.fetchTrendingPeople(timeWindow: .day)
    }
    
    func didTapOnTrendingPeople(index: Int, nav: UINavigationController?) {
        guard let people = trendingResults else {return}
        query = DiscoverQuery()
        query?.addOrRemovePeople(people: people[index])
        if let router = router as? DiscoverPresenterToRouterProtocol, let query = query, let nav = nav {
            router.pushToResultsScreen(navigationController: nav, for: query, mediaType: .movie, shouldShowHeader: false)
        }
    }
}

extension DiscoverPresenter: DiscoverInteractorToPresenterProtocol {
    
    func keywordsFetchSuccess(results: GenericSearchResults?) {
        guard let keywords = results?.results else { return }
        self.keywords = []
        for keyword in keywords {
            let aux = TypedSearchResult.createFromParent(keyword)
            aux.createKeyword()
            self.keywords?.append(aux)
        }
        
        if let view = getView(type: DiscoverPresenterToViewProtocol.self) {
            view.onKeywordsFetched()
        }
    }
    
    func keywordsFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func genresFetchSuccess(results: GenresRLM?) {
        guard let results = results else { return }
        if results.type == .movie {
            moviesGenres = results
        } else {
            showsGenres = results
        }
    }
    
    func genresFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func peopleFetchSuccess(results: GenericSearchResults?) {
        guard let people = results?.results else { return }
        self.people = []
        for person in people {
            let aux = TypedSearchResult.createFromParent(person)
            aux.createPeople()
            self.people?.append(aux)
        }
        
        self.people = Array(self.people!.prefix(3))
        
        if let view = getView(type: DiscoverPresenterToViewProtocol.self) {
            view.onPeopleFetched()
        }
        startFetchingKeywords(term: lastQuery)
    }
    
    func peopleFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func trendingPeopleFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func trendingPeopleFetchSuccess(results: GenericSearchResults?) {
        guard let rawResults = results?.results else { return }
        trendingResults = []
        
        for person in rawResults {
            let aux = TypedSearchResult.createFromParent(person)
            aux.createPeople()
            trendingResults?.append(aux)
        }
        
        if let view = view as? DiscoverPresenterToViewProtocol {
            view.onTrendingPeopleFetched()
        }
    }
}

