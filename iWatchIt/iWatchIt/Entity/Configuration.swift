//
//  Configuration.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 25/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import Foundation
import RealmSwift


class Configuration: Object, Decodable {
    @objc dynamic var imageBaseURL: String = ""
    @objc dynamic var imageSecureBaseURL: String = ""
    @objc dynamic var logoSizes: [String] = []
    @objc dynamic var posterSizes: [String] = []
    @objc dynamic var profileSizes: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case imageBaseURL = "base_url"
        case imageSecureBaseURL = "secure_base_url"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
    }
}
