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
    
    var shouldShowAds: Bool = true
    
    init(firebaseDatabaseProvider: FirebaseDatabaseProviderProtocol = FirebaseDatabaseProvider.shared) {
        self.firebaseDatabaseProvider = firebaseDatabaseProvider
    }
    
    func start() {
        fetchConfiguration()
    }
    
    // MARK: - Private interface
    private func fetchConfiguration() {
        firebaseDatabaseProvider.fetchParameter(parent: DatabaseFields.adManager, name: DatabaseFields.interstitialFrequency, ofType: Int.self) { param in
            if let frequency = param {
                self.interstitialFrequency = frequency
            }
        }
        
        firebaseDatabaseProvider.fetchParameter(parent: DatabaseFields.adManager, name: DatabaseFields.shouldShowAds, ofType: Bool.self) { param in
            if let shouldShowAds = param {
                self.shouldShowAds = shouldShowAds
            }
        }
    }
}
