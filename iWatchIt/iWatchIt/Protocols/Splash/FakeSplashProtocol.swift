//
//  FakeSplashProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

protocol ViewToPresenterProtocol: class{
    var view: SplashPresenterToViewProtocol? {get set}
    var interactor: SplashPresenterToInteractorProtocol? {get set}
    var router: SplashPresenterToRouterProtocol? {get set}
    func startFetchingConfiguration()
    func showHomeController(navigationController:UINavigationController)
}

protocol SplashPresenterToViewProtocol: class{
    func onConfigurationFetched()
    func showError()
}

protocol SplashPresenterToRouterProtocol: class {
    static func createModule() -> FakeSplashVC
    func pushToHomeScreen(navigationConroller:UINavigationController)
}

protocol SplashPresenterToInteractorProtocol: class {
    var presenter:SplashInteractorToPresenterProtocol? {get set}
    func fetchConfiguration()
}

protocol SplashInteractorToPresenterProtocol: class {
    func configurationFetchedSuccess(configuration: Configuration)
    func configurationFetchedFailed()
}
