//
//  DetailRouter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//


import UIKit

class DetailRouter: BaseRouter, DetailPresenterToRouterProtocol {
    func presentReviews(for id: Int, navigationController: UINavigationController) {
        
    }
    
    func createModule() -> DetailVC {
        let view = kStoryboardHome.instantiateViewController(identifier: kDetailVC) as! DetailVC
        
        let presenter: DetailViewToPresenterProtocol & DetailInteractorToPresenterProtocol = DetailPresenter()
        let interactor: DetailPresenterToInteractorProtocol = DetailInteractor(presenter: presenter)
        let router: DetailPresenterToRouterProtocol = DetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
    static let shared = DetailRouter()
}

