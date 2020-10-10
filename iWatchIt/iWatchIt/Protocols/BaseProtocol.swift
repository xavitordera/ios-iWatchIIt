//
//  BaseProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 26/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

protocol BaseViewToPresenterProtocol: class{
    var view: BasePresenterToViewProtocol? {get set}
    var interactor: BasePresenterToInteractorProtocol? {get set}
    var router: BasePresenterToRouterProtocol? {get set}
}

protocol BasePresenterToViewProtocol: class{
    var presenter:BaseViewToPresenterProtocol? {get set}
    func showError(message: String?)
}

protocol BasePresenterToRouterProtocol: class {}

protocol BasePresenterToInteractorProtocol: class {
    var presenter:BaseInteractorToPresenterProtocol? {get set}
}

protocol BaseInteractorToPresenterProtocol: class {}


