//
//  Discover.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

struct DiscoverQuery {
    var type: MediaType = .movie
    var keywords: [Keyword]?
    var genres: [Genre]?
    var people: [People]?
}

struct Keyword: Decodable {
    var name: String?
    var id: Int64?
}

struct People: Decodable {
    var name: String?
    var id: Int64?
}
