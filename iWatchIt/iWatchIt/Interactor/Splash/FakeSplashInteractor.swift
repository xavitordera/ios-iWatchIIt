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
}
