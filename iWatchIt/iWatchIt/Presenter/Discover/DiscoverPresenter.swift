//
//  DiscoverPresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverPresenter: BasePresenter {
    var query: DiscoverQuery?
}


extension DiscoverPresenter: DiscoverViewToPresenterProtocol {
    
    func startFetchingKeywords(term: String) {
        
    }
    
    func startFilteringGenres(term: String, mediaType: MediaType) {
        
    }
    
    func startFetchingPeople(term: String) {
            
    }
    
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType) {
        
    }
    
    
}

extension DiscoverPresenter: DiscoverInteractorToPresenterProtocol {
    func keywordsFetchSuccess(results: RootKeyword?) {
        
    }
    
    func keywordsFetchFailed(message: String?) {
        
    }
    
    func genresFetchSuccess(results: GenresRLM?) {
        
    }
    
    func genresFetchFailed(message: String?) {
        
    }
    
    func peopleFetchSuccess(results: RootPeople?) {
        
    }
    
    func peopleFetchFailed(message: String?) {
        
    }
}
