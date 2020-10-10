//
//  PreferenceManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 11/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

class Preference {
    static func getCurrentCountry() -> String {
        let langRegion = Locale.current.regionCode ?? "us"
        return langRegion.lowercased()
    }
    
    static func getLocaleLanguage() -> String {
        let langStr = Locale.current.languageCode ?? "en"
        return langStr
    }
}
