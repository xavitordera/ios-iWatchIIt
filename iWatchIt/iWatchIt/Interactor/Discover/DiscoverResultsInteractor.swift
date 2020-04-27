//
//  DiscoverResultsInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 19/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

class DiscoverResultsInteractor: BaseInteractor, DiscoverResultsPresenterToInteractorProtocol {
    
    init(presenter: DiscoverResultsInteractorToPresenterProtocol) {
        super.init()
        self.presenter = presenter
    }
    
    func fetchDiscoverResults(query: DiscoverQuery, mediaType: MediaType) {
        APIService.shared.discoverExtended(mediaType: mediaType, language: Preference.getLocaleLanguage(), withGenres: query.getFormattedIds(for: .Genres), withPeople: query.getFormattedIds(for: .People), withKeywords: query.getFormattedIds(for: .Keywords), page: 1) { (results, error) in
            
            guard let presenter = self.presenter as? DiscoverResultsInteractorToPresenterProtocol else {
                return
            }
            
            guard let results = results else {
                presenter.discoverResultsFetchFailed(message: error?.localizedDescription)
                return
            }
            
            presenter.discoverResultsFetchSuccess(results: results, mediaType: mediaType)
        }
    }
}
