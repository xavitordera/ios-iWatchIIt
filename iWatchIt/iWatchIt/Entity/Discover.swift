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
    var keywords: [Keyword] = []
    var genres: [GenreRLM] = []
    var people: [People] = []
    static var shared = DiscoverQuery()
    
    mutating func addOrRemoveKeyword(keyword: Keyword) {
        if self.keywords.contains(keyword), let index = self.keywords.firstIndex(of: keyword) {
            self.keywords.remove(at: index)
        } else {
            self.keywords.append(keyword)
        }
    }
    
    mutating func addOrRemoveGenre(genre: GenreRLM) {
        if self.genres.contains(genre), let index = self.genres.firstIndex(of: genre) {
            self.genres.remove(at: index)
        } else {
            self.genres.append(genre)
        }
    }
    
    mutating func addOrRemovePeople(people: People) {
        if self.people.contains(people), let index = self.people.firstIndex(of: people) {
            self.people.remove(at: index)
        } else {
            self.people.append(people)
        }
    }
    
    func keywordIsInQuery(keyword: Keyword) -> Bool {
        return keywords.contains(keyword)
    }
    
    func genreIsInQuery(genre: GenreRLM) -> Bool {
        return genres.contains(genre)
    }
    
    func peopleIsInQuery(people: People) -> Bool {
        return self.people.contains(people)
    }
    
    func getIdsForType(type: DiscoverType) -> [Int64]? {
        switch type {
        case .Keywords:
            return keywords.map{ $0.id ?? -1 }
        case .Genres:
            return genres.map{ $0.id }
        case .People:
            return people.map{ $0.id ?? -1 }
        }
    }
}

struct Keyword: Decodable, Equatable {
    var name: String?
    var id: Int64?
}

struct People: Decodable, Equatable {
    var name: String?
    var id: Int64?
}
