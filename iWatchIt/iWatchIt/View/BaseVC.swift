//
//  BaseVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

class BaseVC: UIViewController, BasePresenterToViewProtocol {
    var presenter: BaseViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showError(message: String?) {
        let alert = AlertHelper.alertWith(title: "app_error_title".localized, message: message)
        present(alert, animated: true, completion: nil)
    }
}
