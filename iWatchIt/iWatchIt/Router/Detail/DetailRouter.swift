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
    
    func pushDiscoverResults(query: DiscoverQuery, nav: UINavigationController?) {
        let vc = DiscoverResultsRouter.shared.createModule(with: query.title ?? "")
        
        vc.query = query
        vc.mediaType = .movie
        vc.shouldShowSegmentedHeader = false
        
        if let nav = nav {
            nav.pushViewController(vc, animated: true)
        }
    }
    
    func createModule(with id: Int, and type: MediaType) -> DetailVC {
        let view = kStoryboardDetail.instantiateViewController(identifier: kDetailVC) as! DetailVC
        
        let presenter: DetailViewToPresenterProtocol & DetailInteractorToPresenterProtocol = DetailPresenter()
        let interactor: DetailPresenterToInteractorProtocol = DetailInteractor(presenter: presenter)
        let router: DetailPresenterToRouterProtocol = DetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        view.contentId = id
        view.type = type
        
        return view
    }
    
    static let shared = DetailRouter()
}

