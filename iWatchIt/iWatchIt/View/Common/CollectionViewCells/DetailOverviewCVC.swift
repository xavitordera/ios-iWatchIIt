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
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
    }
    
    func configureCell(with score: Double?, and title: String, and description: String?) {
        lblTitle.text = title
        lblDescription.text = description
        if let score = score, score > 0.0 {
            btnScore.setTitle(String(format: "%.1f", score), for: .normal)
            btnScore.isHidden = false
            setupStars(for: score)
        } else {
            btnScore.isHidden = true
            hideStars()
        }
    }

    private func setupStars(for score: Double) {
        
        imgStar1.isHidden = false
        imgStar2.isHidden = false
        imgStar3.isHidden = false
        imgStar4.isHidden = false
        imgStar5.isHidden = false
        
        if score > 0.0 && score < 2.0 {
            imgStar1.image = kStarHalf
        } else if score >= 2.0 {
            imgStar1.image = kStarFilled
        }
        
        if score > 2.0 && score < 4.0 {
            imgStar2.image = kStarHalf
        } else if score >= 4.0 {
            imgStar2.image = kStarFilled
        }
        
        if score > 4.0 && score < 6.0 {
            imgStar3.image = kStarHalf
        } else if score >= 6.0 {
            imgStar3.image = kStarFilled
        }
        
        if score > 6.0 && score < 8.0 {
            imgStar4.image = kStarHalf
        } else if score >= 8.0 {
            imgStar4.image = kStarFilled
        }
        
        if score > 8.0 && score < 10.0 {
            imgStar5.image = kStarHalf
        } else if score >= 10.0 {
            imgStar5.image = kStarFilled
        }
    }

    private func hideStars() {
        imgStar1.isHidden = true
        imgStar2.isHidden = true
        imgStar3.isHidden = true
        imgStar4.isHidden = true
        imgStar5.isHidden = true
    }
}
