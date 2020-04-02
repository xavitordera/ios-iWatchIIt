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
    func startFetchingDetail(type: MediaType?, id: Int?)
}

protocol DetailPresenterToViewProtocol: BasePresenterToViewProtocol{
    func onDetailFetched()
}

protocol DetailPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func presentReviews(for id: Int, navigationController: UINavigationController)
}

protocol DetailPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchDetail(type: MediaType, id: Int, language: String)
    func saveRecentlySeen(id: Int?, title: String?, type: MediaType?)
}

protocol DetailInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func detailFetchSuccess(detail: ContentExtended?)
    func detailFetchFailed(message: String?)
}
