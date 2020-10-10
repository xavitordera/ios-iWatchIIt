//
//  DiscoverPeopleTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 17/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverPeopleTVC: UITableViewCell, Reusable {
    
    var people: TypedSearchResult?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        people = nil
    }
    
    func configureCell(people: TypedSearchResult?) {
        self.people = people
        
        guard let people = people else {return}
        
        textLabel?.text = people.name
        var detail = people.department ?? ""
        
        if people.mediaType != nil {
            detail += " in Movies"
        }
        
        detailTextLabel?.text = detail
    }
    
    func setupLayout() {
        tintColor = .whiteOrBlack
        textLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        detailTextLabel?.font = .systemFont(ofSize: 16.0, weight: .regular)
        textLabel?.textColor = .whiteOrBlack
        detailTextLabel?.textColor = UIColor.whiteOrBlack.withAlphaComponent(0.6)
        imageView?.image = UIImage(systemName: "person.crop.circle")
        selectionStyle = .none
    }
}
