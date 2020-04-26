//
//  DiscoverInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

class DiscoverInteractor: BaseInteractor {
    init(presenter: DiscoverInteractorToPresenterProtocol) {
        super.init()
        self.presenter = presenter
    }
}

extension DiscoverInteractor: DiscoverPresenterToInteractorProtocol {
    
    func fetchKeywords(term: String) {
        APIService.shared.searchKeyword(query: term) { (result, error) in
            guard let presenter = self.getPresenter(type: DiscoverInteractorToPresenterProtocol.self) else {return}
            guard let result = result else {
                presenter.keywordsFetchFailed(message: "\(error ?? AppError.generic)")
                return
            }
            presenter.keywordsFetchSuccess(results: result)
        }
    }
    
    func fetchGenres(mediaType: MediaType) {
        guard let presenter = self.getPresenter(type: DiscoverInteractorToPresenterProtocol.self) else {return}
        do {
            let genres = try RealmManager.getObjects(type: GenresRLM.self, filter: String(format: "privateType == '%@'", mediaType.rawValue)).first
            presenter.genresFetchSuccess(results: genres)
        } catch let error {
            presenter.genresFetchFailed(message: "\(error)")
        }
    }
    
    func fetchPeople(term: String) {
        APIService.shared.searchPeople(query: term, language: Preference.getLocaleLanguage()) { (result, error) in
            guard let presenter = self.getPresenter(type: DiscoverInteractorToPresenterProtocol.self) else {return}
            guard let result = result else {
                presenter.peopleFetchFailed(message: "\(error ?? AppError.generic)")
                return
            }
            presenter.peopleFetchSuccess(results: result)
        }
    }
    
    func fetchTrendingPeople(timeWindow: TimeWindow) {
        APIService.shared.getTrendingPeople(mediaType: .people, timeWindow: timeWindow, language: Preference.getLocaleLanguage()) { (result, error) in
            
            
            guard let presenter = self.getPresenter(type: DiscoverInteractorToPresenterProtocol.self) else {return}
            guard let result = result else {
                presenter.trendingPeopleFetchFailed(message: error.debugDescription)
                return
            }
            
            presenter.trendingPeopleFetchSuccess(results: result)
        }
    }
}
