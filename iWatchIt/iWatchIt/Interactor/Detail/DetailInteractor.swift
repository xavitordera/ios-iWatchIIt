//
//  DetailInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 02/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

class DetailInteractor: BaseInteractor, DetailPresenterToInteractorProtocol {
    
    init(presenter: DetailInteractorToPresenterProtocol) {
        super.init()
        self.presenter = presenter
    }
    
    func fetchDetail(type: MediaType, id: Int, language: String) {
        APIService.shared.detail(mediaType: type, id: id, language: "en", appendToResponse: kGETDetailVideos) { (result, error) in
            guard let presenter = self.getPresenter() else {
                return
            }
            
            guard let result = result else {
                presenter.detailFetchFailed(message: error?.localizedDescription)
                return
            }
            
            presenter.detailFetchSuccess(detail: result)
        }
    }
    
    func saveRecentlySeen(id: Int?, title: String?, type: MediaType?) {
        RecentlySeenHelper.saveRecentlySeen(id: id, title: title, mediaType: type)
    }
    
    func getPresenter() -> DetailInteractorToPresenterProtocol? {
        guard let presenter = presenter as? DetailInteractorToPresenterProtocol else {
            return nil
        }
        return presenter
    }
}
