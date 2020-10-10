//
//  WatchlistManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 30/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

protocol WatchlistManagerDelegate {
    func didChangeWatchlist(type: MediaType)
}

class WatchlistManager {
    private var delegates: [WatchlistManagerDelegate] = []
    
    static let shared = WatchlistManager()
    
    func addToWatchlist(content: ContentExtended?, type: MediaType?) {
        guard let content = content, let type = type else { return }
        let entry = WatchlistContent.createFromDetail(detail: content, and: type)
        do {
            try RealmManager.saveObject(object: entry)
            notifyWatchlistChanged(type: type)
        } catch let error {
            debugPrint("ERROR SAVING Watchlist: \(error)")
        }
    }
    
    func addDelegate(delegate: WatchlistManagerDelegate) {
        delegates.append(delegate)
    }
    
    func notifyWatchlistChanged(type: MediaType) {
        for delegate in delegates {
            delegate.didChangeWatchlist(type: type)
        }
    }
    
    func removeFromWatchlist(id: Int, type: MediaType) {
        do {
            try RealmManager.removeObject(type: WatchlistContent.self, filter: String(format: "id == %d AND privateType == '%@'", id, type.rawValue))
            notifyWatchlistChanged(type: type)
        } catch let error {
            debugPrint(error)
        }
    }
    
    func isInWatchlist(id: Int, type: MediaType) -> Bool {
        do {
            let objects = try RealmManager.getObjects(type: WatchlistContent.self, filter: String(format: "id == %d AND privateType == '%@'", id, type.rawValue))
            return (!objects.isEmpty)
        } catch let error {
            debugPrint("ERROR \(error)")
        }
        return false
    }
    
    func getWatchlist(type: MediaType) -> [WatchlistContent]? {
        do {
            return try RealmManager.getObjects(type: WatchlistContent.self, filter: String(format: "privateType == '%@'", type.rawValue))
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}
