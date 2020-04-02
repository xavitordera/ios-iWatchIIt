//
//  HomeProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

protocol HomeViewToPresenterProtocol: BaseViewToPresenterProtocol{
    var home: Home? { get set }
    func startFetchingData(type: MediaType)
    func contentSelected(for movieId: Int, navigationController: UINavigationController)
}

protocol HomePresenterToViewProtocol: BasePresenterToViewProtocol{
    func onDataFetched()
}

protocol HomePresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToDetailScreen(for movieId: Int, navigationController: UINavigationController)
}

protocol HomePresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchTrending(type: MediaType, timeWindow: TimeWindow)
    func fetchDiscover(type: MediaType)
}

protocol HomeInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func trendingFetchSuccess(trending: Root?)
    func trendingFetchFailed(message: String?)
    func discoverFetchSuccess(discover: Root?)
    func discoverFetchFailed(message: String?)
}
