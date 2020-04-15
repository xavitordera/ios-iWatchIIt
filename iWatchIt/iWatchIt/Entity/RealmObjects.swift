//
//  RealmObjects.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import RealmSwift
import Foundation

class ConfigurationRLM: Object {
    @objc dynamic var imageBaseURL: String = ""
    @objc dynamic var imageSecureBaseURL: String = ""
    let logoSizes = List<String>()
    let posterSizes = List<String>()
    let profileSizes = List<String>()
    
    static func createFromAPI(config: Configuration) -> ConfigurationRLM {
        let configRlm = ConfigurationRLM()
        configRlm.imageBaseURL = config.imageBaseURL
        configRlm.imageSecureBaseURL = config.imageSecureBaseURL
        configRlm.logoSizes.append(objectsIn: config.logoSizes)
        configRlm.posterSizes.append(objectsIn: config.posterSizes)
        configRlm.profileSizes.append(objectsIn: config.profileSizes)
        
        return configRlm
    }
}

class GenresRLM: Object {
    @objc private dynamic var privateType: String = MediaType.movie.rawValue
    var type: MediaType {
        get { return MediaType(rawValue: privateType)! }
        set { privateType = newValue.rawValue }
    }
    let genres = List<GenreRLM>()
    
    static func createFromRoot(root: RootGenres, type: MediaType) -> GenresRLM {
        let genres = GenresRLM()
        guard let results = root.genres else { return genres }
        
        for result in results {
            let genreItem = GenreRLM()
            genreItem.id = result.id ?? 0
            genreItem.name = result.name ?? ""
            genres.genres.append(genreItem)
        }
        genres.type = type
        return genres
    }
}

class GenreRLM: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var id: Int64 = 0
}
