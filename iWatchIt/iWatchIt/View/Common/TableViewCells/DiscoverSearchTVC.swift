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
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var removeBtn: UIButton!
    var keyword: Keyword?
    var genre: GenreRLM?
    
    // MARK: - UITVC
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textLabel?.textColor = .whiteOrBlack
        self.tintColor = .whiteOrBlack
    }
    
    override func prepareForReuse() {
//        lblTitle.text = ""
//        removeBtn.isHidden = true
        keyword = nil
        genre = nil
        imageView?.image = nil
//        removeBtn.setImage(nil, for: .normal)
        accessoryView = UIView()
    }
    
    // MARK: - Public interface
    func configureCell(keyword: Keyword?, genre: GenreRLM?) {
        self.keyword = keyword
        self.genre = genre
//        lblTitle.text = keyword?.name ?? genre?.name
        self.textLabel?.text = keyword?.name ?? genre?.name
        self.accessoryType = .detailButton
        
        
        if let keyword = keyword {
            let image = DiscoverQuery.shared.keywordIsInQuery(keyword: keyword) ? UIImage(systemName: "xmark") : UIImage(systemName: "plus")
//            removeBtn.setImage(image, for: .normal)
            self.imageView?.image = UIImage(systemName: "tag")
            accessoryView = UIImageView.init(image: image)
        } else if let genre = genre {
//            removeBtn.isHidden = DiscoverQuery.shared.genreIsInQuery(genre: genre)
            let image = DiscoverQuery.shared.genreIsInQuery(genre: genre) ? UIImage(systemName: "xmark") : UIImage(systemName: "plus")
            self.imageView?.image = UIImage(systemName: "tv.circle")
            accessoryView = UIImageView.init(image: image)
        }
    }
    
    func configureEmpty(type: DiscoverType) {
        textLabel?.textColor = kColorEmptyStateLabel
        textLabel?.text = type == .Keywords ? "Add keywords to discover their content" : "Add genres to discover their content"
        textLabel?.font = .systemFont(ofSize: 15.0, weight: .light)
    }
    
}
