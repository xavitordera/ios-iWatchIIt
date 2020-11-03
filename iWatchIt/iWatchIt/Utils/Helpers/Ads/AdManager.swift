//
//  AdManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/08/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import GoogleMobileAds



final class AdManager: NSObject {
    // MARK: - Public interface
    static let shared = AdManager()
    
    /// default value
    var interstitialFrequency = 5
    
    var firebaseDatabaseProvider: FirebaseDatabaseProviderProtocol
    
    init(firebaseDatabaseProvider: FirebaseDatabaseProviderProtocol = FirebaseDatabaseProvider.shared) {
        self.firebaseDatabaseProvider = firebaseDatabaseProvider
    }
    
    func start() {
        interstitial = createAndLoadInterstitial()
        fetchConfiguration()
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
        let interstitial = GADInterstitial(adUnitID: kAdMobIDInterstitial)
        
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    private func controllerAttached() {
        timesAttached += 1
        if timesAttached == interstitialFrequency {
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
    
    private func fetchConfiguration() {
        firebaseDatabaseProvider.fetchParameter(parent: DatabaseFields.adManager, name: DatabaseFields.interstitialFrequency, ofType: Int.self) { param in
            if let frequency = param {
                self.interstitialFrequency = frequency
            }
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
