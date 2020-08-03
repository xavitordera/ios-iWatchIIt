//
//  AdManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/08/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import GoogleMobileAds

let kMaxTimes = 3

final class AdManager: NSObject {
    // MARK: - Public interface
    static let shared = AdManager()
    
    func start() {
        interstitial = createAndLoadInterstitial()
    }
    
    func attach(_ viewController: UIViewController) {
        currentController = viewController
        controllerAttached()
    }
    
    func deattach() {
        currentController = nil
    }
    
    // MARK: - Private interface
    private var currentController: UIViewController?
    private var timesAttached = 0
    private var interstitial: GADInterstitial!
    
    private func createAndLoadInterstitial() -> GADInterstitial {
        #if DEBUG
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        #else
        let interstitial = GADInterstitial(adUnitID: kAdMobID)
        #endif
        
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    private func controllerAttached() {
        timesAttached += 1
        if timesAttached == kMaxTimes {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.botherUser()
                self.timesAttached = 0
            }
        }
    }
    
    /// I'm sorry bro, want my money
    private func botherUser() {
        if interstitial.isReady, let controller = currentController {
            interstitial.present(fromRootViewController: controller)
        } else {
            print("Ad wasn't ready")
        }
    }
}

extension AdManager: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        debugPrint(error)
    }
}
