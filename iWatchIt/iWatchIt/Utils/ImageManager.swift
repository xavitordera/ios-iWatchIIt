//
//  ImageManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

enum LogoSize: String {
    case w45 = "w45"
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w342 = "w342"
    case w500 = "w500"
    case original = "original"
}

enum PosterSize: String {
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w342 = "w342"
    case w500 = "w500"
    case w780 = "w780"
    case original = "original"
}

enum ProfileSize: String {
    case small
    case xxmedium
    case xmedium
    case medium
    case xbig
    case big
    case original = "original"
}

final class ImageManager {
    
    static func createImageURL(path: String, size: String) -> String {
        do {
            let configAll = try RealmManager.getObjects(type: ConfigurationRLM.self)
            
            guard let config = configAll.first, let baseURL = URL(string:config.imageSecureBaseURL) else {
                return ""
            }
            
    
            
            
        } catch let error {
            debugPrint(error)
        }
    }
    
}
