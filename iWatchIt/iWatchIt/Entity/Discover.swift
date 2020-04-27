//
//  Discover.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

protocol DiscoverQueryDelegate: class {
    func didUpdateQuery()
}

class GenericSearch: Codable {
    var id: Int64?
    var name: String?
    var image: String?
    var department: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case image = "profile_path"
        case department = "known_for_department"
    }
}

class TypedSearchResult: GenericSearch, Equatable {
    static func == (lhs: TypedSearchResult, rhs: TypedSearchResult) -> Bool {
        return lhs.discoverType == rhs.discoverType && lhs.id == rhs.id && lhs.name == rhs.name && lhs.image == rhs.image && lhs.department == rhs.department && lhs.mediaType == rhs.mediaType
    }
    
    var discoverType: DiscoverType?
    var mediaType: MediaType?
    
    static func createFromGenre(genre: GenreRLM, withMediaType: MediaType) -> TypedSearchResult {
        
        let obj = TypedSearchResult()
        obj.id = genre.id
        obj.name = genre.name
        obj.discoverType = .Genres
        obj.mediaType = withMediaType
        
        return obj
    }
    
    static func createFromParent(_ parent: GenericSearch) -> TypedSearchResult {
        let obj = TypedSearchResult()
        obj.id = parent.id
        obj.image = parent.image
        obj.department = parent.department
        obj.name = parent.name
        
        return obj
    }
    
    func createKeyword() {
        discoverType = .Keywords
    }
    
    func createPeople() {
        discoverType = .People
        mediaType = .movie
    }
    
    func createGenre(mediaType: MediaType) {
        discoverType = .Genres
        self.mediaType = mediaType
    }
}

class GenericSearchResults: Codable {
    var results: [GenericSearch]?
}

class DiscoverQuery {
    var type: MediaType = .movie
    var keywords: [TypedSearchResult] = []
    var genres: [TypedSearchResult] = []
    var people: [TypedSearchResult] = []
    static var shared = DiscoverQuery()
    var delegates: [DiscoverQueryDelegate] = []
    
    func addOrRemoveKeyword(keyword: TypedSearchResult) {
        if self.keywords.contains(keyword), let index = self.keywords.firstIndex(of: keyword) {
            self.keywords.remove(at: index)
        } else {
            self.keywords.append(keyword)
        }
        notifyQueryChanged()
    }
    
    func addOrRemoveGenre(genre: TypedSearchResult) {
        if self.genres.contains(genre), let index = self.genres.firstIndex(of: genre) {
            self.genres.remove(at: index)
        } else {
            self.genres.append(genre)
        }
        notifyQueryChanged()
    }
    
    func addOrRemovePeople(people: TypedSearchResult) {
        if self.people.contains(people), let index = self.people.firstIndex(of: people) {
            self.people.remove(at: index)
        } else {
            self.people.append(people)
        }
        notifyQueryChanged()
    }
    
    func keywordIsInQuery(keyword: TypedSearchResult) -> Bool {
        return keywords.contains(keyword)
    }
    
    func genreIsInQuery(genre: TypedSearchResult) -> Bool {
        return genres.contains(genre)
    }
    
    func peopleIsInQuery(people: TypedSearchResult) -> Bool {
        return self.people.contains(people)
    }
    
    private func getIdsForType(type: DiscoverType) -> [Int]? {
        switch type {
        case .Keywords:
            return keywords.map{ Int($0.id ?? -1) }
        case .Genres:
            return genres.map{ Int($0.id ?? -1) }
        case .People:
            return people.map{ Int($0.id ?? -1) }
        }
    }
    
    func getFormattedIds(for type: DiscoverType) -> String {
        guard let ids = getIdsForType(type: type) else {
            return ""
        }
        return ids.map({"\($0)"}).joined(separator: ",")
    }
    
    func addDelegate(delegate: DiscoverQueryDelegate) {
        delegates.append(delegate)
    }
    
    func notifyQueryChanged() {
        for delegate in delegates {
            delegate.didUpdateQuery()
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
    var image: String?
    var department: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case image = "profile_path"
        case department = "known_for_department"
    }
}
