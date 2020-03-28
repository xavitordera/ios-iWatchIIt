//
//  Configuration.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 25/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import Foundation
import RealmSwift


class Configuration: Decodable {
    var imageBaseURL: String = ""
    var imageSecureBaseURL: String = ""
    var logoSizes: [String] = []
    var posterSizes: [String] = []
    var profileSizes: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case imageBaseURL = "base_url"
        case imageSecureBaseURL = "secure_base_url"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
    }
}

class RootConfiguration: Decodable {
    var images: Configuration
}

class ConfigurationRLM: Object {
    @objc dynamic var imageBaseURL: String = ""
    @objc dynamic var imageSecureBaseURL: String = ""
    let logoSizes = List<String>()
    let posterSizes = List<String>()
    let profileSizes = List<String>()
    
    static func createFromAPI(config: Configuration) -> ConfigurationRLM {
        let configRlm = ConfigurationRLM()
        configRlm.imageBaseURL = config.imageBaseURL
        configRlm.imageSecureBaseURL = config.imageSecureBaseURL
        configRlm.logoSizes.append(objectsIn: config.logoSizes)
        configRlm.posterSizes.append(objectsIn: config.posterSizes)
        configRlm.profileSizes.append(objectsIn: config.profileSizes)
        
        return configRlm
    }
}
