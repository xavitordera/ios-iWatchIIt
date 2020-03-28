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
    
    func fetchTrending(type: MediaType) {
        // fetch trending
    }
    
    func fetchDiscover(type: MediaType) {
        // fetch discover
    }
}
