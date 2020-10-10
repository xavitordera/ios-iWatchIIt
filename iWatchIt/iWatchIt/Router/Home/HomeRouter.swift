//
//  HomeRouter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class HomeRouter: BaseRouter, HomePresenterToRouterProtocol {
    
    func pushToDetailScreen(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType) {
        let detail = DetailRouter.shared.createModule(with: contentWithId, and: mediaType)
        navigationController.pushViewController(detail, animated: true)
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
        let view = kStoryboardHome.instantiateViewController(withIdentifier: kMoviesVC) as! MoviesVC
        
        setupModule(view: view)
        
        return view
    }
    
    func createShowsModule() -> ShowsVC {
        let view = kStoryboardHome.instantiateViewController(withIdentifier: kShowsVC) as! ShowsVC
        
        setupModule(view: view)
        
        return view
    }
    
    static let shared = HomeRouter()
}
