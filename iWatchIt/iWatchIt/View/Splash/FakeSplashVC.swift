//
//  FakeSplashVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit
import Lottie

class FakeSplashVC: BaseVC, SplashPresenterToViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNav()
        setupAnimation()
        loadData()
    }
    
    func setup() {
        view.backgroundColor = .darkGray
        let view = UIView(frame: self.view.frame)
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
        self.view.insertSubview(view, at: 0)
    }
    
    func setupNav() {
        setNavigationBarHidden(isHidden: true)
    }
    
    func setupAnimation() {
        let animation = AnimationView(name: kLogoAnimation)
        animation.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width)
        animation.center = self.view.center
        animation.contentMode = .scaleAspectFill
        view.addSubview(animation)
        animation.play { _ in
            guard let presenter = self.getPresenter() else {
                return
            }
            presenter.showHomeController(navigationController: self.navigationController!)
        }
    }
    
    func getPresenter() -> SplashViewToPresenterProtocol? {
        guard let presenter = self.presenter as? SplashViewToPresenterProtocol else {
            self.showError(message: "app_error_generic".localized)
            return nil
        }
        return presenter
    }
    
    func loadData() {
        guard let presenter = getPresenter() else {return}
        presenter.startFetchingConfiguration()
        presenter.startFetchingGenres()
    }
}
