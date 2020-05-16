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
    var page: Int?
    var totalPages: Int?
    
    static func createFromRoot(root: Root?) -> Search {
        var search = Search()
        search.results = root?.results
        search.page = root?.page
        search.totalPages = root?.totalPages
        return search
    }
}
