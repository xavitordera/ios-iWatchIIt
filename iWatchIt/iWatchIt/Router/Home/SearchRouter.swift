//
//  SearchRouter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class SearchRouter: BaseRouter, SearchPresenterToRouterProtocol {
    func pushToDetailScreen(navigationController: UINavigationController) {
        
    }
    
    func createModule() -> SearchVC {
        let view = kStoryboardMain.instantiateViewController(identifier: kSearchVC) as! SearchVC
        
        let presenter: SearchViewToPresenterProtocol & SearchInteractorToPresenterProtocol = SearchPresenter()
        let interactor: SearchPresenterToInteractorProtocol = SearchInteractor(presenter: presenter)
        let router: SearchPresenterToRouterProtocol = SearchRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
    static let shared = SearchRouter()
}

