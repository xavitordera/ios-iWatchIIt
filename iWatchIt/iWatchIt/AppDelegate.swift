//
//  AppDelegate.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        loadFirstScreen()
        initRealm()
        initFirebase()
        
        return true
    }
    
    func loadFirstScreen() {
        let splash = FakeSplashRouter.shared.createModule()
        Navigation.shared.setNavigationController(firstVC: splash)
    }
    
    func initRealm() {
        RealmManager.initRealm()
    }
    
    func initFirebase() {
        FirebaseApp.configure()
    }
}

