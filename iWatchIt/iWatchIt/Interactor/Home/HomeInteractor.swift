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
    
    func fetchTrending(type: MediaType, timeWindow: TimeWindow = .week) {
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
    }
    
    func getPresenter() -> HomeInteractorToPresenterProtocol? {
        guard let presenter = presenter as? HomeInteractorToPresenterProtocol else {
            return nil
        }
        return presenter
    }
}
