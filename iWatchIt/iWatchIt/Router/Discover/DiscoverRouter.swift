//
//  DiscoverRouter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverRouter: BaseRouter, DiscoverPresenterToRouterProtocol {
    func pushToResultsScreen(navigationController: UINavigationController, for searchQuery: DiscoverQuery) {
        
    }
    
    func createModule() -> DiscoverVC {
        let view = kStoryboardHome.instantiateViewController(identifier: kDiscoverVC) as! DiscoverVC
        
        let presenter: DiscoverViewToPresenterProtocol & DiscoverInteractorToPresenterProtocol = DiscoverPresenter()
        let interactor: DiscoverPresenterToInteractorProtocol = DiscoverInteractor(presenter: presenter)
        let router: DiscoverPresenterToRouterProtocol = DiscoverRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.query = DiscoverQuery.shared
        
        return view
    }
    
    func createSearchInfoModule() -> SearchInfoVC {
        let view = SearchInfoVC(nibName: kSearchInfoVC, bundle: nil)
        
        return view
    }
    
    static let shared = DiscoverRouter()
}
