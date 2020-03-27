//
//  BasePresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//


class BasePresenter: BaseViewToPresenterProtocol {
    var view: BasePresenterToViewProtocol?
    var interactor: BasePresenterToInteractorProtocol?
    var router: BasePresenterToRouterProtocol? 
}