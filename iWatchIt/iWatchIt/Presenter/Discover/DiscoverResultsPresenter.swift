//
//  DiscoverResultsPresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 19/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverResultsPresenter: BasePresenter, DiscoverResultsViewToPresenterProtocol, DiscoverResultsInteractorToPresenterProtocol {
    
    var movieResults: Search?
    var showsResults: Search?
    
    var query: DiscoverQuery?
    
    func startFetchingData(query: DiscoverQuery, type: MediaType) {
        self.query = query
        if let interactor = interactor as? DiscoverResultsPresenterToInteractorProtocol {
            interactor.fetchDiscoverResults(query: query, mediaType: type, page: 1)
        }
    }
    
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType) {
        if let router = router as? DiscoverResultsPresenterToRouterProtocol {
            router.pushToDetailScreen(navigationController: navigationController, for: contentWithId, and: mediaType)
        }
    }
    
    func discoverResultsFetchSuccess(results: Root?, mediaType: MediaType) {
        let discoverResults = Search.createFromRoot(root: results)
        if let view = view as? DiscoverResultsPresenterToViewProtocol {
            
            manageResults(discoverResults: discoverResults, mediaType: mediaType)
            
            switch mediaType {
            case .movie:
                view.onMoviesFetched(isEmpty: movieResults?.results?.isEmpty ?? true)
            case .show:
                view.onShowsFetched(isEmpty: showsResults?.results?.isEmpty ?? true)
            case .people:
                break
            }
        } else {
            view?.showError(message: AppError.generic.errorDescription)
        }
    }
    
    func discoverResultsFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func shouldShowSegmentedHeader(query: DiscoverQuery?) -> Bool {
        return query?.type == nil
    }
    
    private func manageResults(discoverResults: Search, mediaType: MediaType) {
        guard let results = discoverResults.results else {return}
        switch mediaType {
        case .movie:
            if let page = discoverResults.page, movieResults?.page != nil, page > movieResults!.page! {
                movieResults?.results?.append(contentsOf: results)
                movieResults?.page! += 1
            } else if let page = discoverResults.page, page == 1 {
                movieResults = discoverResults
            }
            
        case .show:
            
            if let page = discoverResults.page,  showsResults?.page != nil, page > showsResults!.page! {
                showsResults?.results?.append(contentsOf: results)
                showsResults?.page! += 1
            } else if let page = discoverResults.page, page == 1 {
                showsResults = discoverResults
            }
            
        case .people:
            break
        }
    }
    
    func didChangeType(type: MediaType) {
        guard let query = query else {return}
        switch type {
        case .movie:
            if movieResults == nil {
                startFetchingData(query: query, type: .movie)
            }
        default:
            if showsResults == nil {
                startFetchingData(query: query, type: .show)
            }
        }
    }
    
    func didReachEnd(type: MediaType) {
        var typeResults: Search?
        switch type {
           case .movie:
               typeResults = movieResults
           default:
               typeResults = showsResults
        }
        
        guard let results = typeResults, let query = query else { return }
        
        if let page = results.page, let totalPages = results.totalPages {
            if page < totalPages {
                if let interactor = interactor as? DiscoverResultsPresenterToInteractorProtocol {
                    interactor.fetchDiscoverResults(query: query, mediaType: type, page: page + 1)
                }
            }
        }
    }
}
