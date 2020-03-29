//
//  Search.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

struct Search {
    var results: [Content]?
    
    static func createFromRoot(root: Root?) -> Search {
        var search = Search()
        search.results = root?.results
        return search
    }
}
