//
//  FakeSplashInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation
import Alamofire

class FakeSplashInteractor: BaseInteractor, SplashPresenterToInteractorProtocol{
    var presenter: SplashInteractorToPresenterProtocol
    
    init(presenter: SplashInteractorToPresenterProtocol) {
        presenter = presenter
    }
    
    func fetchConfiguration() {
        APIService.shared.getConfiguration() {[weak self] (configuration, error) in
            guard let configuration = configuration as? Configuration else {
                self?.presenter.configurationFetchedFailed(error)
                return
            }
            
            self?.presenter.configurationFetchedSuccess(configuration)
        }
    }
}
