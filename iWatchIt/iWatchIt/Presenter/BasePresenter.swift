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
    
    func getView<T>(type: T.Type) -> T? {
        guard let view = view as? T else {
            return nil
        }
        return view
    }
}
