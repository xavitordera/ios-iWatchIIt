//
//  DiscoverResultsProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

protocol DiscoverResultsViewToPresenterProtocol: BaseViewToPresenterProtocol{
    var discoverResults: Search? { get set }
    func startFetchingData(query: DiscoverQuery, type: MediaType)
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType)
}

protocol DiscoverResultsPresenterToViewProtocol: BasePresenterToViewProtocol{
    func onDataFetched(isEmpty: Bool)
}

protocol DiscoverResultsPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToDetailScreen(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType)
}

protocol DiscoverResultsPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchDiscoverResults(query: DiscoverQuery, mediaType: MediaType)
}

protocol DiscoverResultsInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func discoverResultsFetchSuccess(results: Root?)
    func discoverResultsFetchFailed(message: String?)
}
