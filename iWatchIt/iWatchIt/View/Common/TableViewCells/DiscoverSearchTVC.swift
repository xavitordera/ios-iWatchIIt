//
//  DiscoverSearchTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 13/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverSearchTVC: UITableViewCell, Reusable {
    
    // MARK: - Properties
    var keyword: TypedSearchResult?
    var genre: TypedSearchResult?
    
    // MARK: - UITVC
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textLabel?.textColor = .whiteOrBlack
        tintColor = .whiteOrBlack
        detailTextLabel?.textColor = UIColor.whiteOrBlack.withAlphaComponent(0.6)
    }
    
    override func prepareForReuse() {
        keyword = nil
        genre = nil
        imageView?.image = nil
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
    // MARK: - Public interface
    func configureCell(keyword: TypedSearchResult?, genre: TypedSearchResult?) {
        self.keyword = keyword
        self.genre = genre
        //        textLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
        
        textLabel?.text = keyword?.name ?? genre?.name
        detailTextLabel?.text = keyword == nil ? "in Genres" : nil
        if let _ = keyword {
            self.imageView?.image = kTabDiscoverImg
        } else if let _ = genre {
            self.imageView?.image = UIImage(systemName: "tv.circle")
        }
    }
}
