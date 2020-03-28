//
//  HomeProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

protocol HomeViewToPresenterProtocol: BaseViewToPresenterProtocol{
    func startFetchingTrending(type: MediaType)
    func startFetchingDiscover(type: MediaType)
    func showDetailController(navigationController: UINavigationController)
}

protocol HomePresenterToViewProtocol: BasePresenterToViewProtocol{}

protocol HomePresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToDetailScreen(navigationController: UINavigationController)
}

protocol HomePresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchTrending(type: MediaType)
    func fetchDiscover(type: MediaType)
}

protocol HomeInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func trendingFetchSuccess(trending: Any)
    func trendingFetchFailed(message: String?)
    func discoverFetchSuccess(trending: Any)
    func discoverFetchFailed(message: String?)
}
