//
//  Search.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import Foundation
import RealmSwift

struct Search {
    var results: [Content]?
    
    static func createFromRoot(root: Root?) -> Search {
        var search = Search()
        search.results = root?.results
        return search
    }
}


class RecentlySeen: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    private dynamic var privateType: String = MediaType.movie.rawValue
    var type: MediaType {
        get { return MediaType(rawValue: privateType)! }
        set { privateType = newValue.rawValue }
    }
}
