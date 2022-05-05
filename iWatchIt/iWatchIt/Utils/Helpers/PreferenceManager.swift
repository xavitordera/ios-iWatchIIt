//
//  PreferenceManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 11/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

let defaults = UserDefaults.standard

class Preference {
    static func getCurrentCountry() -> String {
        let langRegion = Locale.current.regionCode ?? "us"
        return langRegion.lowercased()
    }
    
    static func getLocaleLanguage() -> String {
        let langStr = Locale.current.languageCode ?? "en"
        return langStr
    }
    
    static func getUtellyKeys() -> [String] {
        guard let keys = defaults.array(forKey: DatabaseFields.utellyKeys) as? [String] else {
            return [kUtellyAPIKey]
        }
        return keys
    }
    
    static func setUtellyKeys(keys: [String]) {
        defaults.set(keys, forKey: DatabaseFields.utellyKeys)
    }

    static func getRetryNumber() -> Int {
        defaults.integer(forKey: DatabaseFields.retryNumber)
    }

    static func setRetryNumber(_ retryNumber: Int) {
        defaults.set(retryNumber, forKey: DatabaseFields.retryNumber)
    }
}
