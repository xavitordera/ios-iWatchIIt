//
//  SearchProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

protocol SearchViewToPresenterProtocol: BaseViewToPresenterProtocol{
    var search: Search? { get set }
    func startFetchingData(query: String, type: MediaType)
    func showDetailController(navigationController: UINavigationController)
}

protocol SearchPresenterToViewProtocol: BasePresenterToViewProtocol{
    func onDataFetched()
}

protocol SearchPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToDetailScreen(navigationController: UINavigationController)
}

protocol SearchPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchSearch(query: String, mediaType: MediaType)
}

protocol SearchInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func searchFetchSuccess(results: Root?)
    func searchFetchFailed(message: String?)
}
