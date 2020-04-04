//
//  WatchlistManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 30/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

protocol WatchlistManagerDelegate {
    func didAddToWatchlist(id: Int)
    func didRemoveFromWatchlist(id: Int)
}

class WatchlistManager {
    private var delegates: [WatchlistManagerDelegate] = []
    
    static let shared = WatchlistManager()
    
    func addToWatchlist(content: Content?) {
        guard let content = content else { return }
        for delegate in delegates {
            delegate.didAddToWatchlist(id: content.id!)
        }
    }
    
    func removeFromWatchlist(id: Int) {
        for delegate in delegates {
            delegate.didRemoveFromWatchlist(id: id)
        }
    }
    
    func isInWatchlist(id: Int) -> Bool {
        return false
    }

    func addDelegate(delegate: WatchlistManagerDelegate) {
        delegates.append(delegate)
    }
}
