//
//  DiscoverResultsProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

protocol DiscoverResultsViewToPresenterProtocol: BaseViewToPresenterProtocol{
    var movieResults: Search? { get set }
    var showsResults: Search? { get set }
    func startFetchingData(query: DiscoverQuery, type: MediaType)
    func shouldShowSegmentedHeader(query: DiscoverQuery?) -> Bool
    func didChangeType(type: MediaType)
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType)
}

protocol DiscoverResultsPresenterToViewProtocol: BasePresenterToViewProtocol{
    func onMoviesFetched(isEmpty: Bool)
    func onShowsFetched(isEmpty: Bool)
}

protocol DiscoverResultsPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToDetailScreen(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType)
}

protocol DiscoverResultsPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchDiscoverResults(query: DiscoverQuery, mediaType: MediaType, page: Int)
}

protocol DiscoverResultsInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func discoverResultsFetchSuccess(results: Root?, mediaType: MediaType)
    func discoverResultsFetchFailed(message: String?)
}
