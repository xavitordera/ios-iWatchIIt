//
//  Navigation.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 26/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

final class Navigation {
    static let shared = Navigation()
    
    private var navigationController: UINavigationController?
    private let window = UIWindow(frame: UIScreen.main.bounds)
    
    func setNavigationController(firstVC controller: UIViewController) {
        self.navigationController = UINavigationController(rootViewController: controller)
        
        if let navController = self.navigationController {
            setRootController(navController)
        }
    }
    
    func setRootController(_ controller: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil ) {
        
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            window.rootViewController = controller
            CATransaction.commit()
        } else {
            window.rootViewController = controller
            completion?()
        }
        
        window.makeKeyAndVisible()
    }
    
    func popToRootViewController() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func currentController() -> UIViewController? {
        
        if let navigationVC = window.rootViewController as? UINavigationController {
            return navigationVC.topViewController
        }
        
        return window.rootViewController // Splash
    }
}


