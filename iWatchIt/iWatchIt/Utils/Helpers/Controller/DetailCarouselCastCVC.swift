//
//  DetailCarouselCVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DetailCarouselCastCVC: UICollectionViewCell, NibReusable {
    
    // MARK: - Properties
    var cast: Cast?
    
    var delegate: InfiniteCarouselCVCDelegate?
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var artistImage: UIImageView!
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cast = nil
        artistImage.image = nil
        delegate = nil
        lblTitle.text = nil
    }
    
    // MARK: - Public interface
    func configureCell(cast: Cast?) {
        self.cast = cast
        
        setupCastCell()
    }
    
    func setupCastCell() {
        guard let cast = cast else {
            return
        }
        // setup image
        if let imgPath = cast.image, let imageURL = ImageHelper.createImageURL(path: imgPath, size: .profile(size: .medium)) {
            artistImage.imageFrom(url: imageURL)
        } else {
            // No image for this person :(
            if let gender = cast.gender, gender == Gender.female.rawValue {
                artistImage.image = kEmptyStateUserFemale
            } else {
                artistImage.image = kEmptyStateUserMale
            }
        }
        
        artistImage.roundCornersForAspectFit(radius: 8)
        // setup name
        lblTitle.isHidden = false
        lblTitle.text = cast.name
    }
    // MARK: - Auxiliar functions
    
    private func setupLayout() {
        lblTitle.font = .systemFont(ofSize: 12.0, weight: .light)
        lblTitle.textColor = .white
        lblTitle.numberOfLines = 0

        artistImage.contentMode = .scaleAspectFit
    }
}
