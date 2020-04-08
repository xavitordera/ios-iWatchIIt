//
//  DetailProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 02/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

protocol DetailViewToPresenterProtocol: BaseViewToPresenterProtocol{
    var detail: ContentExtended? { get set }
    var type: MediaType? { get set }
    var platforms: [Platform]? { get set }
    func startFetchingDetail(type: MediaType?, id: Int?)
    func startFetchingPlatform(term: String)
    func didTapOnPlatform(platform: Platform?)
}

protocol DetailPresenterToViewProtocol: BasePresenterToViewProtocol{
    func onDetailFetched()
    func onPlatformsFetched()
}

protocol DetailPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func presentReviews(for id: Int, navigationController: UINavigationController)
}

protocol DetailPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchDetail(type: MediaType, id: Int, language: String)
    func fetchPlatforms(term: String)
    func saveRecentlySeen(id: Int?, title: String?, type: MediaType?)
}

protocol DetailInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func detailFetchSuccess(detail: ContentExtended?)
    func detailFetchFailed(message: String?)
    func platformsFetchSuccess(platforms: RootPlatform?)
    func platformsFetchFailed(message: String?)
}
