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
    case YouTube = "YouTube"
}

struct Platform: Decodable {
    var url: String?
    var displayName: String?
    
    enum CodingKeys: String, CodingKey {
        case url
        case displayName = "display_name"
    }
}

struct Cast: Decodable {
    var name: String?
    var image: String?
    var gender: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case image = "profile_path"
        case gender
    }
}

struct Video: Decodable {
    var name: String?
    var key: String?
    var site: String?
}

struct Genre: Decodable {
    var id: Int?
    var name: String?
}

struct PlatformExternalIdResults: Decodable {
    var tmdb: PlatformExternalId?
}

struct PlatformExternalId: Decodable {
    var id: String?
}

extension ContentExtended {
    func createDescriptionForHeader() -> String {
        var description = ""
        
        if let runtime = self.runtime {
            let h: Int = runtime / 60
            let m = runtime % 60
            if h > 0 {
                description.append(String(format: "%dh%dm", h, m))
            } else {
                description.append(String(format: "%dm", m))
            }
            
            description.append(" · ")
        }
        
        if let genres = self.genres, let first = genres.first, let name = first.name {
            description.append(String(name))
            description.append(" · ")
        }
        
        if let date = self.movieReleaseDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let dateAsDate = formatter.date(from: date) {
                description.append(String(Calendar.current.component(.year, from: dateAsDate)))
            }
        } else if let date = self.firstAirDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let dateAsDate = formatter.date(from: date) {
                description.append(String(Calendar.current.component(.year, from: dateAsDate)))
            }
        }
        
        if let nseason = numberOfSeasons, nseason > 0 {
            description.append(" · ")
            description.append(String(format: "detail_header_seasons".localized, nseason))
        }
        
        return description
    }
}
