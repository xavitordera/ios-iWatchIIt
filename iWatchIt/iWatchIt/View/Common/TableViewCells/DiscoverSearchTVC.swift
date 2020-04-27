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
        setupLayout()
    }
    
    override func prepareForReuse() {
        keyword = nil
        genre = nil
        imageView?.image = nil
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
    func setupLayout() {
        tintColor = .whiteOrBlack
        textLabel?.textColor = .whiteOrBlack
        detailTextLabel?.textColor = UIColor.whiteOrBlack.withAlphaComponent(0.6)
        textLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        detailTextLabel?.font = .systemFont(ofSize: 16.0, weight: .regular)
        selectionStyle = .none
    }
    
    // MARK: - Public interface
    func configureCell(keyword: TypedSearchResult?, genre: TypedSearchResult?) {
        self.keyword = keyword
        self.genre = genre
        textLabel?.text = keyword?.name ?? genre?.name
        if let _ = keyword {
            self.imageView?.image = kTabDiscoverImg
            detailTextLabel?.text = nil
        } else if let genre = genre {
            self.imageView?.image = UIImage(systemName: "tv.circle")
            var detail = "in Genres "
            if let type = genre.mediaType {
                switch type {
                case .movie:
                    detail += "in Movies"
                case .show:
                    detail += "in TV Shows"
                case .people:
                    break
                }
            }
            detailTextLabel?.text = detail
        }
        
        
    }
}
