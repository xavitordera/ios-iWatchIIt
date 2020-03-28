//
//  FakeSplashRouter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

class FakeSplashRouter: BaseRouter, SplashPresenterToRouterProtocol {
    func createModule() -> FakeSplashVC {
        let view = kStoryboardMain.instantiateViewController(withIdentifier: kFakeSpashVC) as! FakeSplashVC
        
        let presenter: SplashViewToPresenterProtocol & SplashInteractorToPresenterProtocol = FakeSplashPresenter()
        let interactor: SplashPresenterToInteractorProtocol = FakeSplashInteractor(presenter: presenter)
        let router:SplashPresenterToRouterProtocol = FakeSplashRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
    static let shared: FakeSplashRouter = FakeSplashRouter()

    func pushToHomeScreen(navigationConroller navigationController:UINavigationController) {
        let tabBar = TabBarVC()
        navigationController.pushViewController(tabBar, animated: true)
    }
}
