//
//  AppDelegate.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

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
    
    func initGoogleAds() {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2f9e0612b4e8f7792a10c6602e28dce6"]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            if let dynamicLink = dynamiclink {
                DynamicLinkHandler.shared.manage(link: dynamicLink)
            }
        }
        
        return handled
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return application(app, open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                         annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
        // Handle the deep link. For example, show the deep-linked content or
        // apply a promotional offer to the user's account.
        // ...
        DynamicLinkHandler.shared.manage(link: dynamicLink)
        return true
      }
      return false
    }
}

