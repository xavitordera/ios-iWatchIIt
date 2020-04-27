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
    
    func startFetchingData(query: DiscoverQuery, type: MediaType) {
        if let interactor = interactor as? DiscoverResultsPresenterToInteractorProtocol {
            interactor.fetchDiscoverResults(query: query, mediaType: type)
        }
    }
    
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType) {
        if let router = router as? DiscoverResultsPresenterToRouterProtocol {
            router.pushToDetailScreen(navigationController: navigationController, for: contentWithId, and: mediaType)
        }
    }
    
    func discoverResultsFetchSuccess(results: Root?, mediaType: MediaType) {
        let discoverResults = Search.createFromRoot(root: results)
        if let view = view as? DiscoverResultsPresenterToViewProtocol, let results = results?.results {
            switch mediaType {
            case .movie:
                movieResults = discoverResults
                view.onMoviesFetched(isEmpty: results.isEmpty)
            case .show:
                showsResults = discoverResults
                view.onShowsFetched(isEmpty: results.isEmpty)
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
}
