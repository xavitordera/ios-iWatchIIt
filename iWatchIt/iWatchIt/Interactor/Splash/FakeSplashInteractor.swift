//
//  FakeSplashInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation
import Alamofire

class FakeSplashInteractor: BaseInteractor, SplashPresenterToInteractorProtocol {
    
    init(presenter: SplashInteractorToPresenterProtocol) {
        super.init()
        self.presenter = presenter
    }
    
    func fetchConfiguration() {
        APIService.shared.getConfiguration() {[weak self] (configuration, error) in
            
            guard let presenter = self?.presenter as? SplashInteractorToPresenterProtocol else {return}
            
            guard let configuration = configuration else {
                presenter.configurationFetchedFailed(message: error?.localizedDescription)
                return
            }
            
            presenter.configurationFetchedSuccess(configuration: configuration)
        }
    }
    
    func fetchGenres(type: MediaType) {
        APIService.shared.getGenres(mediaType: type, language: Preference.getLocaleLanguage()) {[weak self] (genres, error) in
            
            guard let presenter = self?.presenter as? SplashInteractorToPresenterProtocol else {return}
            
            guard let genres = genres else {
                presenter.configurationFetchedFailed(message: error?.localizedDescription)
                return
            }
            
            presenter.genresFetchedSuccess(genres:genres, mediaType: type)
        }
    }
}
