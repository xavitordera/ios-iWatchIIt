//
//  DetailHeaderCVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 04/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DetailHeaderCVC: UICollectionViewCell, NibReusable {
    
    
    @IBOutlet weak var posterImg: UIImageView!
    
    @IBOutlet weak var infoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    private func setupLayout() {
        infoLbl.font = .systemFont(ofSize: 14.0, weight: .thin)
        infoLbl.textColor = .white
        contentView.addGradient(startColor: UIColor.black.withAlphaComponent(0.35), endColor: UIColor.black.withAlphaComponent(0.85))
    }
    
    func configureCell(with imgPath: String?, and description: String?) {
        infoLbl.text = description
        
        guard let imgPath = imgPath, let imageURL = ImageHelper.createImageURL(path: imgPath, size: .poster(size: .medium)) else {
            posterImg.image = kEmptyStateMedia
            return
        }
        
        posterImg.imageFrom(url: imageURL)
    }

}
