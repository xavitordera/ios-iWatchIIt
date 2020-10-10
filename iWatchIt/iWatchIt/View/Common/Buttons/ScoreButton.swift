//
//  AverageButton.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 01/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

@IBDesignable
class ScoreButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 3.0
        self.imageView?.image = kMovieStar
        self.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .medium)
        self.titleLabel?.textColor = .white
        self.backgroundColor = .darkGray
    }
    
    func configure(with score: Double) {
        self.titleLabel?.text = String(format: "%.1f", score)
    }
}

