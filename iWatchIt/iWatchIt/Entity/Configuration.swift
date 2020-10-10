//
//  Configuration.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 25/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import Foundation

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
