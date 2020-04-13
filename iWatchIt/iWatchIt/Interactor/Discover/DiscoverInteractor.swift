//
//  DiscoverInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

class DiscoverInteractor: BaseInteractor {
    init(presenter: DiscoverInteractorToPresenterProtocol) {
        super.init()
        self.presenter = presenter
    }
}

extension DiscoverInteractor: DiscoverPresenterToInteractorProtocol {
    func fetchKeywords(term: String) {
        
    }
    
    func fetchGenres(mediaType: String) {
        
    }
    
    func fetchPeople(term: String) {
        
    }
}
