//
//  RecentlySeenManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 30/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//


final class RecentlySeenHelper {
    
    static func saveRecentlySeen(id: Int?, title: String?, mediaType: MediaType?) {
        
        guard let id = id, let title = title, let mediaType = mediaType else {
            return
        }
        
        let entry = RecentlySeen()
        entry.id = id
        entry.title = title
        entry.type = mediaType
        
        do {
            try RealmManager.saveObject(object: entry)
        
        } catch let error {
            debugPrint("Could not save entry \(error)")
        }
    }
    
    static func getRecentlySeen(type: MediaType) -> [RecentlySeen]? {
        do {
            let wholeResults = try RealmManager.getObjects(type: RecentlySeen.self, filter: String(format: "privateType == '%@'", type.rawValue))
            let results = Array(wholeResults.suffix(6))
            return results.reversed()
        } catch let error {
            debugPrint("Could not save entry \(error)")
            return nil
        }
    }
}
