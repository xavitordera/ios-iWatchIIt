//
//  Watchlist.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 10/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation
import RealmSwift

class WatchlistContent: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc private dynamic var privateType: String = MediaType.movie.rawValue
    @objc dynamic var image: String = ""
    @objc dynamic var voteAverage: Double = 0.0
    var type: MediaType {
        get { return MediaType(rawValue: privateType)! }
        set { privateType = newValue.rawValue }
    }
    
    
    /// Creates a Watchlist item from a given Content Extended
    /// - parameter detail: Content to get info from
    /// - parameter type: Type of content
    /// - returns: Watchlist item
    class func createFromDetail(detail: ContentExtended, and type: MediaType) -> WatchlistContent {
        
        let content = WatchlistContent()
        content.id = detail.id ?? 0
        content.image = detail.image ?? ""
        content.type = type
        content.title = detail.title ?? detail.name ?? ""
        content.voteAverage = detail.voteAverage ?? 0.0
        
        return content
    }
}

