//
//  HomePresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

class HomePresenter: BasePresenter, HomeInteractorToPresenterProtocol, HomeViewToPresenterProtocol {
    
    var home: Home?
    var type: MediaType = .movie
    
    // MARK: Interactor protocol
    func trendingFetchSuccess(trending: Root?) {
        home = Home.updateFromRoot(rootTrending: trending, rootDiscover: nil, rootTopRated: nil, watchlist: nil, type: type)
        if let view = getView() {
            view.onDataFetched()
        }
    }
    
    func trendingFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func discoverFetchSuccess(discover: Root?) {
        home = Home.updateFromRoot(rootTrending: nil, rootDiscover: discover, rootTopRated: nil, watchlist: nil, type: type)
        if let view = getView() {
            view.onDataFetched()
        }
    }
    
    func discoverFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func topRatedFetchSuccess(topRated: Root?) {
        home = Home.updateFromRoot(rootTrending: nil, rootDiscover: nil, rootTopRated: topRated, watchlist: nil, type: type)
        if let view = getView() {
            view.onDataFetched()
        }
    }
    
    func topRatedFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func watchlistFetched(watchlist: [WatchlistContent]?) {
        home = Home.updateFromRoot(rootTrending: nil, rootDiscover: nil, rootTopRated: nil, watchlist: watchlist, type: type)
        if let view = getView() {
            view.onDataFetched()
        }
        WatchlistManager.shared.addDelegate(delegate: self)
    }
    
    // MARK: View protocol
    
    func startFetchingData(type: MediaType) {
        guard let interactor = interactor as? HomePresenterToInteractorProtocol else {
            discoverFetchFailed(message: "app_error_generic".localized)
            return
        }
        self.type = type
    
        
        interactor.fetchTrending(type: type, timeWindow: TimeWindow.day)
        interactor.fetchDiscover(type: type)
        interactor.fetchTopRated(type: type)
        interactor.fetchWatchlist(type: type)
    }
    
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType) {
        guard let router = self.router as? HomePresenterToRouterProtocol else { return }
        router.pushToDetailScreen(navigationController: navigationController, for: contentWithId, and: mediaType)
    }
    
    func getView() -> HomePresenterToViewProtocol? {
        guard let view = self.view as? HomePresenterToViewProtocol else {
            return nil
        }
        return view
    }
}

extension HomePresenter: WatchlistManagerDelegate {
    func didChangeWatchlist(type: MediaType) {
        if let interactor = interactor as? HomePresenterToInteractorProtocol, type == self.type {
            interactor.fetchWatchlist(type: type)
        }
    }
}
