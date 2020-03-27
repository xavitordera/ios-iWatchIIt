//
//  FakeSplashProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

protocol SplashViewToPresenterProtocol: BaseViewToPresenterProtocol{
    func startFetchingConfiguration()
    func showHomeController(navigationController:UINavigationController)
}

protocol SplashPresenterToViewProtocol: BasePresenterToViewProtocol{}

protocol SplashPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToHomeScreen(navigationConroller:UINavigationController)
}

protocol SplashPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchConfiguration()
}

protocol SplashInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func configurationFetchedSuccess(configuration: Configuration)
    func configurationFetchedFailed(message: String?)
}
