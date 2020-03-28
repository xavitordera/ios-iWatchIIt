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
    
    // MARK: Interactor protocol
    func trendingFetchSuccess(trending: Any) {
            
    }
    
    func trendingFetchFailed(message: String?) {
        
    }
    
    func discoverFetchSuccess(trending: Any) {
        
    }
    
    func discoverFetchFailed(message: String?) {
        
    }
    
    // MARK: View protocol
    
    func startFetchingTrending(type: MediaType) {
        
    }
    
    func startFetchingDiscover(type: MediaType) {
        
    }
    
    func showDetailController(navigationController: UINavigationController) {
        
    }
}
