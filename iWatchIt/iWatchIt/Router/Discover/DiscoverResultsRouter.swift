//
//  DiscoverResultsRouter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 19/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverResultsRouter: BaseRouter, DiscoverResultsPresenterToRouterProtocol {
    func pushToDetailScreen(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType) {
        let detail = DetailRouter.shared.createModule(with: contentWithId, and: mediaType)
        navigationController.pushViewController(detail, animated: true)
    }
    
    static let shared = DiscoverResultsRouter()
    
    func createModule(with title: String) -> DiscoverResultsVC {
        let view = kStoryboardHome.instantiateViewController(identifier: kDiscoverResultsVC) as! DiscoverResultsVC
        
        let presenter: DiscoverResultsViewToPresenterProtocol & DiscoverResultsInteractorToPresenterProtocol = DiscoverResultsPresenter()
        let interactor: DiscoverResultsPresenterToInteractorProtocol = DiscoverResultsInteractor(presenter: presenter)
        let router: DiscoverResultsPresenterToRouterProtocol = DiscoverResultsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        view.searchTitle = title
        
        return view
    }

}
