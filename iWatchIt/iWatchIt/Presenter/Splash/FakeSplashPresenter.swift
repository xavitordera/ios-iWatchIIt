//
//  FakeSplashPresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class FakeSplashPresenter:BasePresenter, SplashViewToPresenterProtocol {
    
    func startFetchingConfiguration() {
        guard let interactor = self.interactor as? SplashPresenterToInteractorProtocol else { return }
        interactor.fetchConfiguration()
    }
    
    func showHomeController(navigationController: UINavigationController) {
        guard let router = router as? SplashPresenterToRouterProtocol else { return }
        router.pushToHomeScreen(navigationConroller: navigationController)
    }
}

extension FakeSplashPresenter: SplashInteractorToPresenterProtocol{
    func configurationFetchedFailed(message: String?) {
        debugPrint("Configuration fetch failed: error -> ")
    }
    
    func configurationFetchedSuccess(configuration: Configuration) {
        do {
            try RealmManager.saveObject(object: configuration)
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
