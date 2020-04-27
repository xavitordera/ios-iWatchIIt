//
//  DiscoverHelper.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

class DiscoverHelper {
    static var searchResults = GenericSearchResults()
    
    static func updateResults(search: GenericSearchResults?, with people: [GenericSearch]?, genres: [TypedSearchResult]?, keywords: [GenericSearch]?) -> GenericSearchResults? {
        guard let search = search else {return nil}
        
        if search.results == nil {
            search.results = []
        }
        
        if let people = people, people.isEmpty {
            if let first = people.first, let f = first as? TypedSearchResult {
                f.createPeople()
                search.results!.append(f)
            }
        }
        
        if let genres = genres, genres.isEmpty {
            if let first = genres.first {
                search.results!.append(first)
            }
        }
        
        if let keywords = keywords as? [TypedSearchResult] {
            search.results!.append(contentsOf: keywords)
        }
        
        return searchResults
    }
    
    private func sortSearch(search: GenericSearchResults) {
        guard let search = search.results as? [TypedSearchResult] else {return}
        
        var auxArr: [TypedSearchResult] = []
        for result in search {
            guard let type = result.discoverType else {return}
            if type == .Genres {
                auxArr.append(result)
            }
        }
        
    }
}
