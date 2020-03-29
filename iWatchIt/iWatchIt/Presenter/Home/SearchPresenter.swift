//
//  SearchPresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

class SearchPresenter: BasePresenter, SearchInteractorToPresenterProtocol, SearchViewToPresenterProtocol {
    
    var search: Search?
    
    // MARK: Interactor protocol
    func searchFetchSuccess(results: Root?) {
        search = Search.createFromRoot(root: results)
        if let view = getView() {
            view.onDataFetched()
        }
    }
    
    func searchFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    // MARK: View protocol
    
    func startFetchingData(query: String, type: MediaType) {
        guard let interactor = interactor as? SearchPresenterToInteractorProtocol else {
            searchFetchFailed(message: "app_error_generic".localized)
            return
        }
        interactor.fetchSearch(query: query, mediaType: type)
    }
    
    func showDetailController(navigationController: UINavigationController) {
        
    }
    
    func getView() -> SearchPresenterToViewProtocol? {
        guard let view = self.view as? SearchPresenterToViewProtocol else {
            return nil
        }
        return view
    }
}
