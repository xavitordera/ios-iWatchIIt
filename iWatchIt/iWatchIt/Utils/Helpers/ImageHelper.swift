//
//  ImageManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

enum LogoSize: CaseIterable {
    case small
    case xxmedium
    case xmedium
    case medium
    case xbig
    case big
    case original
}

enum PosterSize: CaseIterable {
    case small
    case xxmedium
    case xmedium
    case medium
    case xbig
    case big
    case original
}

enum ProfileSize: CaseIterable {
    case small
    case medium
    case big
    case original
}

enum ImageSize {
    case logo(size: LogoSize)
    case poster(size: PosterSize)
    case profile(size: ProfileSize)
}

 class ImageHelper {
    
    class func createImageURL(path: String, size: ImageSize) -> URL? {
        do {
            let configAll = try RealmManager.getObjects(type: ConfigurationRLM.self)
            
            guard let config = configAll.first,
                var baseURL = URL(string:config.imageSecureBaseURL), let size = getSize(from: size, and: config) else {
                    return nil
            }
            
            baseURL.appendPathComponent(size)
            baseURL.appendPathComponent(path)
            
            return baseURL
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
    
    class func getSize(from size: ImageSize, and config: ConfigurationRLM) -> String? {
        switch size {
        case .logo(let logoSize):
            if config.logoSizes.count < LogoSize.allCases.count {
                return config.logoSizes.first
            }
            guard let index = LogoSize.allCases.firstIndex(of: logoSize), index < config.logoSizes.count else {
                return nil
            }
            
            return config.logoSizes[index]
            
        case .poster(let posterSize):
            if config.posterSizes.count < PosterSize.allCases.count {
                return config.posterSizes.first
            }
            guard let index = PosterSize.allCases.firstIndex(of: posterSize), index < config.posterSizes.count else {
                return nil
            }
            
            return config.posterSizes[index]
            
        case .profile(let profileSize):
            if config.profileSizes.count < ProfileSize.allCases.count {
                return config.profileSizes.first
            }
            guard let index = ProfileSize.allCases.firstIndex(of: profileSize), index < config.profileSizes.count else {
                return nil
            }
            
            return config.profileSizes[index]
        }
    }
}


