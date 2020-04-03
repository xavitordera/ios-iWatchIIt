//
//  Detail.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

enum Gender: Int, Decodable  {
    case female = 1
    case male = 2
}

enum VideoSite: String, Decodable  {
    case Youtube = "Youtube"
}

struct Platform: Decodable {
    
}

struct Cast: Decodable {
    var name: String?
    var image: String?
    var gender: Gender?
    
    enum CodingKeys: String, CodingKey {
        case name
        case image = "profile_path"
        case gender
    }
}

struct Video: Decodable {
    var name: String?
    var image: String?
    var url: String?
    var key: String?
    var site: VideoSite?
}

struct RootVideo: Decodable {
    var results: [Video]?
}

