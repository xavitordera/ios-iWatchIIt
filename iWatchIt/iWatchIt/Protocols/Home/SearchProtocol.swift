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
    var recentlySeen: [RecentlySeen]? { get set }
    var lastQuery: String? { get set }
    func startFetchingHistory(type: MediaType)
    func startFetchingData(query: String, type: MediaType)
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType)
}

protocol SearchPresenterToViewProtocol: BasePresenterToViewProtocol{
    func onDataFetched(isEmpty: Bool)
    func onRecentlySeenFetched(isEmpty: Bool)
}

protocol SearchPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToDetailScreen(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType)
}

protocol SearchPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchSearch(query: String, mediaType: MediaType)
    func fetchRecentlySeen(mediaType: MediaType)
}

protocol SearchInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func searchFetchSuccess(results: Root?)
    func searchFetchFailed(message: String?)
    func recentlySeenFetchSuccess(results: [RecentlySeen]?)
}
