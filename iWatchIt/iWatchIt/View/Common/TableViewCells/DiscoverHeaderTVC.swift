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

class DiscoverHeaderTVC: UITableViewHeaderFooterView, Reusable {

    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLbl.text = ""
    }
    
    private func setupLayout() {
        titleLbl.font = .systemFont(ofSize: 21.0, weight: .bold)
        titleLbl.textColor = .whiteOrBlack
        contentView.backgroundColor = .blackOrWhite
    }
    
    func configureCell(title: String) {
        titleLbl.text = title
    }
}
