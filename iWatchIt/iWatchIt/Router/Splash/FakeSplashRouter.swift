//
//  FakeSplashRouter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

class FakeSplashRouter: BaseRouter {
    static let shared: FakeSplashRouter = FakeSplashRouter()
    
    override func createModule() -> BaseVC {
        
        let view = FakeSplashRouter.mainstoryboard.instantiateViewController(withIdentifier: "MyViewController") as! FakeSplashVC
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = FakeSplashPresenter()
        let interactor: PresenterToInteractorProtocol = NoticeInteractor()
        let router:PresenterToRouterProtocol = NoticeRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func pushToMovieScreen(navigationConroller navigationController:UINavigationController) {
        
        let movieModue = MovieRouter.createMovieModule()
        navigationController.pushViewController(movieModue,animated: true)
        
    }
}
