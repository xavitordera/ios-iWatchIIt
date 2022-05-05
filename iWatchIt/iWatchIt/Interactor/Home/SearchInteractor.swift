//
//  SearchInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

class SearchInteractor: BaseInteractor, SearchPresenterToInteractorProtocol {
    
    init(presenter: SearchInteractorToPresenterProtocol) {
        super.init()
        self.presenter = presenter
    }
    
    func fetchSearch(query: String) {
        // FIXME: language
        APIService.shared.search(query: query, language: Preference.getLocaleLanguage(), page: 1) { (results, error) in
            guard let presenter = self.getPresenter() else {
                return
            }
            
            guard let results = results else {
                presenter.searchFetchFailed(message: error?.localizedDescription)
                return
            }
            
            presenter.searchFetchSuccess(results: results)
        }
    }
    
    
    func fetchRecentlySeen(mediaType: MediaType) {
        let results = RecentlySeenHelper.getRecentlySeen(type: mediaType)
        self.getPresenter()?.recentlySeenFetchSuccess(results: results)
    }
    
    func getPresenter() -> SearchInteractorToPresenterProtocol? {
        guard let presenter = presenter as? SearchInteractorToPresenterProtocol else {
            return nil
        }
        return presenter
    }
}
