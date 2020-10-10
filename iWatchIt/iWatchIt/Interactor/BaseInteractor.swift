//
//  BaseInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

class BaseInteractor: BasePresenterToInteractorProtocol {
    var presenter: BaseInteractorToPresenterProtocol?
    
    func getPresenter<T> (type: T.Type) -> T? {
        guard let presenter = presenter as? T else { return nil }
        return presenter
    }
}
