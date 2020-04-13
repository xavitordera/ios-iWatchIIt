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
        do {
            let config = try RealmManager.getObjects(type: ConfigurationRLM.self)
            if config.isEmpty {
                interactor.fetchConfiguration()
            }
        } catch let error {
            debugPrint(error)
            interactor.fetchConfiguration()
        }
    }
    
    func startFetchingGenres() {
        guard let interactor = interactor as? SplashPresenterToInteractorProtocol else { return }
        do {
            let storedGenres = try RealmManager.getObjects(type: GenresRLM.self)
            if storedGenres.isEmpty {
                interactor.fetchGenres(type: .movie)
                interactor.fetchGenres(type: .show)
            }
        } catch let error {
            debugPrint(error)
            interactor.fetchGenres(type: .movie)
            interactor.fetchGenres(type: .show)
        }
        
        
    }
    
    func showHomeController(navigationController: UINavigationController) {
        guard let router = router as? SplashPresenterToRouterProtocol else { return }
        router.pushToHomeScreen(navigationConroller: navigationController)
    }
}

extension FakeSplashPresenter: SplashInteractorToPresenterProtocol{
    func genresFetchedSuccess(genres: RootGenres) {
        do {
            let genresRLM = GenresRLM.createFromRoot(root: genres)
            try RealmManager.saveObject(object: genresRLM)
        } catch let error {
            debugPrint(error)
        }
    }
    
    func configurationFetchedFailed(message: String?) {
        view?.showError(message:("Configuration fetch failed: error -> \(String(describing: message))"))
    }
    
    func configurationFetchedSuccess(configuration: Configuration) {
        do {
            let configRLM = ConfigurationRLM.createFromAPI(config: configuration)
            try RealmManager.saveObject(object: configRLM)
        } catch let error {
            debugPrint(error)
        }
    }
}
