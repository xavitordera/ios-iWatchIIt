//
//  SectionHeader.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

class SectionHeader: UICollectionReusableView, NibReusable {
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func setupLayout() {
        self.title.font = .boldSystemFont(ofSize: 22.0)
        self.title.textColor = .whiteOrBlack
    }
    
    func configureHeader(title: String) {
        self.title.text = title
    }

}

