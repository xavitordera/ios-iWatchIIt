//
//  FakeSplashPresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class FakeSplashPresenter:BasePresenter, ViewToPresenterProtocol {
    
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    
    func startFetchingNotice() {
        interactor?.fetchNotice()
    }
    
    func showMovieController(navigationController: UINavigationController) {
        router?.pushToMovieScreen(navigationConroller:navigationController)
    }

}

extension FakeSplashPresenter: SplashInteractorToPresenterProtocol{
    
    func configurationFetchedSuccess(configuration: Configuration) {
        do {
            try RealmManager.saveObject(object: configuration)
        } catch (error) {
            print("Error saving configuration!!!")
        }
    }
    
    func noticeFetchFailed() {
        view?.showError()
    }
    
    
}
