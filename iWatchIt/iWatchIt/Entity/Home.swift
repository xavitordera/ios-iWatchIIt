//
//  Home.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

struct HomeContent: Decodable {
    var image: String = ""
    var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
    }
}
