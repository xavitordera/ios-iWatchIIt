//
//  HomeRouter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class HomeRouter: BaseRouter, HomePresenterToRouterProtocol {
    func pushToDetailScreen(navigationController: UINavigationController) {
        
    }
    
    func setupModule(view: HomeVC) {
        let presenter: HomeViewToPresenterProtocol & HomeInteractorToPresenterProtocol = HomePresenter()
        let interactor: HomePresenterToInteractorProtocol = HomeInteractor(presenter: presenter)
        let router: HomePresenterToRouterProtocol = HomeRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
    }
    
    func createMoviesModule() -> MoviesVC {
        let view = kStoryboardMain.instantiateViewController(withIdentifier: kMoviesVC) as! MoviesVC
        
        setupModule(view: view)
        
        return view
    }
    
    func createShowsModule() -> ShowsVC {
        let view = kStoryboardMain.instantiateViewController(withIdentifier: kShowsVC) as! ShowsVC
        
        setupModule(view: view)
        
        return view
    }
    
    static let shared = HomeRouter()
}
