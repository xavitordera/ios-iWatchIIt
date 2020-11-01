//
//  EventLogger.swift
//  iWatchIt
//
//  Created by Xavier Tordera on 01/11/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import FirebaseAnalytics

enum UserEvents {
    static let utellyReq = "utelly_req"
}

struct EventLogger {
    
    static func logEvent(_ event: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(event, parameters: parameters)
    }
    
}
