//
//  HomeInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

class HomeInteractor: BaseInteractor, HomePresenterToInteractorProtocol {
    
    init(presenter: HomeInteractorToPresenterProtocol) {
        super.init()
        self.presenter = presenter
    }
    
    func fetchTrending(type: MediaType, timeWindow: TimeWindow = .day) {
        APIService.shared.getTrending(mediaType: type, timeWindow: timeWindow, language: Preference.getLocaleLanguage()) { (trending, error) in
            guard let presenter = self.getPresenter() else {
                return
            }
            
            guard let trending = trending else {
                presenter.trendingFetchFailed(message: error?.localizedDescription)
                return
            }
            
            presenter.trendingFetchSuccess(trending: trending)
        }
    }
    
    func fetchDiscover(type: MediaType) {
        // fetch discover
        // FIXME: language and genres
        APIService.shared.discover(mediaType: type, language: Preference.getLocaleLanguage(), withGenres: "") {
            (discover, error) in
            guard let presenter = self.getPresenter() else {
                return
            }
            guard let discover = discover, error == nil else {
                presenter.discoverFetchFailed(message: error?.localizedDescription)
                return
            }
            presenter.discoverFetchSuccess(discover: discover)
        }
    }
    
    func fetchTopRated(type: MediaType) {
        
        APIService.shared.requestObject(
            from: APIRouter.topRated(
                mediaType: type,
                language: Preference.getLocaleLanguage()
            )
        )
        { (result: Result<Root, Error>) in
            guard let presenter = self.getPresenter() else { return }
            switch result {
            case .failure(let error):
                presenter.topRatedFetchFailed(message: error.localizedDescription)
            case .success(let root):
                presenter.topRatedFetchSuccess(topRated: root)
            }
        }
    }
    
    func fetchWatchlist(type: MediaType) {
        let ws = WatchlistManager.shared.getWatchlist(type: type)
        guard let presenter = getPresenter() else { return }
        presenter.watchlistFetched(watchlist: ws)
    }
    
    func getPresenter() -> HomeInteractorToPresenterProtocol? {
        guard let presenter = presenter as? HomeInteractorToPresenterProtocol else {
            return nil
        }
        return presenter
    }
}
