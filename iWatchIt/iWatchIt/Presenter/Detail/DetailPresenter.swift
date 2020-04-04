//
//  DetailPresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

class DetailPresenter: BasePresenter, DetailInteractorToPresenterProtocol, DetailViewToPresenterProtocol {
    
    var detail: ContentExtended?
    var type: MediaType?
    
    // MARK: Interactor protocol
    func detailFetchSuccess(detail: ContentExtended?) {
        self.detail = detail
        if let view = getView() {
            view.onDetailFetched()
        }
        
        guard let interactor = interactor as? DetailPresenterToInteractorProtocol else {
            return
        }
        interactor.saveRecentlySeen(id: detail?.id, title: detail?.title, type: type)
    }
    
    func detailFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    // MARK: View protocol
    
    func startFetchingDetail(type: MediaType?, id: Int?) {
        guard let interactor = interactor as? DetailPresenterToInteractorProtocol,
        let type = type,
        let id = id
        else {
            detailFetchFailed(message: "app_error_generic".localized)
            return
        }
        self.type = type
        interactor.fetchDetail(type: type, id: id, language: "en")
    }
    
    func getView() -> DetailPresenterToViewProtocol? {
        guard let view = self.view as? DetailPresenterToViewProtocol else {
            return nil
        }
        return view
    }
}
