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
    var keywords: [Keyword]?
    var genres: [GenreRLM]?
    var people: [People]?
}


extension DiscoverPresenter: DiscoverViewToPresenterProtocol {
    
    func startFetchingKeywords(term: String) {
        guard let interactor = self.interactor as? DiscoverPresenterToInteractorProtocol else { return  }
        interactor.fetchKeywords(term: term)
    }
    
    func startFilteringGenres(term: String, mediaType: MediaType) {
        guard let interactor = self.interactor as? DiscoverPresenterToInteractorProtocol else { return  }
        interactor.fetchGenres(mediaType: mediaType)
    }
    
    func startFetchingPeople(term: String) {
            guard let interactor = self.interactor as? DiscoverPresenterToInteractorProtocol else { return  }
        interactor.fetchPeople(term: term)
    }
    
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType) {
        
    }
    
}

extension DiscoverPresenter: DiscoverInteractorToPresenterProtocol {
    func keywordsFetchSuccess(results: RootKeyword?) {
        guard let keywords = results?.results else { return }
        self.keywords = keywords
        if let view = getView(type: DiscoverPresenterToViewProtocol.self) {
            view.onKeywordsFetched()
        }
    }
    
    func keywordsFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func genresFetchSuccess(results: GenresRLM?) {
        guard let genres = results?.genres else { return }
        let arrGenres = Array(genres)
        self.genres = arrGenres
        if let view = getView(type: DiscoverPresenterToViewProtocol.self) {
            view.onGenresFiltered()
        }
    }
    
    func genresFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func peopleFetchSuccess(results: RootPeople?) {
        guard let people = results?.results else { return }
        self.people = people
        if let view = getView(type: DiscoverPresenterToViewProtocol.self) {
            view.onPeopleFetched()
        }
    }
    
    func peopleFetchFailed(message: String?) {
        view?.showError(message: message)
    }
}
