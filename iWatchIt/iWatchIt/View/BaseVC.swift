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
        addNotifications()
    }
    
    func addNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    func showError(message: String?) {
        let alert = AlertHelper.simpleAlertWith(title: "app_error_title".localized, message: message, action: "dismiss_pop_up".localized)
        present(alert, animated: true, completion: nil)
    }
    
    func setNavigationBarHidden(isHidden: Bool) {
        self.navigationController?.isNavigationBarHidden = isHidden
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UserDefaults.standard.set(keyboardRectangle.height, forKey: "keyboardHeight")
        }
    }
    
    func getPresenter<T>(type: T.Type) -> T? {
        guard let presenter = self.presenter as? T else { return nil }
        return presenter
    }
}
