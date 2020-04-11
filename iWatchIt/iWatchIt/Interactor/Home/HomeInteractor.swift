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
        APIService.shared.getTrending(mediaType: type, timeWindow: timeWindow) { (trending, error) in
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
        APIService.shared.discover(mediaType: type, language: "en", withGenres: "") {
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
