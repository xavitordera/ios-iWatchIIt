//
//  DetailOverviewCVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 04/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DetailOverviewCVC: UICollectionViewCell, NibReusable {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgStar1: UIImageView!
    @IBOutlet weak var imgStar2: UIImageView!
    @IBOutlet weak var imgStar3: UIImageView!
    @IBOutlet weak var imgStar4: UIImageView!
    @IBOutlet weak var imgStar5: UIImageView!
    
    
    @IBOutlet weak var btnScore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with score: Double?, and description: String?) {
        lblDescription.text = description
        if let score = score, score > 0.0 {
            btnScore.setTitle(String(format: "%.1f", score), for: .normal)
            btnScore.isHidden = false
        } else {
            btnScore.isHidden = true
            hideStars()
        }
    }

    private func setupStars(for score: Double) {
        
    }

    private func hideStars() {
        imgStar1.isHidden = true
        imgStar2.isHidden = true
        imgStar3.isHidden = true
        imgStar4.isHidden = true
        imgStar5.isHidden = true
    }
}
