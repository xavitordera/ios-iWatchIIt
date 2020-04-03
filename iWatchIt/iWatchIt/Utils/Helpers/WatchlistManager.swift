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
    var delegates: [WatchlistManagerDelegate] = []
    
    func addToWatchlist(content: Content) {
        
    }
}
