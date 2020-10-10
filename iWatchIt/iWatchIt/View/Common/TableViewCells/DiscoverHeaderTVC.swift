//
//  DiscoverHeaderTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 13/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

enum DiscoverType {
    case Keywords
    case Genres
    case People
}

protocol DiscoverHeaderDelegate {
    func didExpand(type: DiscoverType)
    func didCollapse(type: DiscoverType)
}

class DiscoverHeaderTVC: UITableViewCell, Reusable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
    }
    
    private func setupLayout() {
        textLabel?.font = .boldSystemFont(ofSize: 24.0)
        textLabel?.textColor = .whiteOrBlack
    }
    
    func configureCell(title: String) {
        textLabel?.text = title
    }
}
