//
//  DetailCarouselCVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DetailCarouselCVC: UICollectionViewCell, NibReusable {
    
    // MARK: - Properties
    var platform: Platform?
    var cast: Cast?
    var video: Video?
    
    var delegate: InfiniteCarouselCVCDelegate?
    
    @IBOutlet weak var coverImgView: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var playImg: UIImageView!
    
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
        
        platform = nil
        cast = nil
        video = nil
        
        coverImgView.image = nil
        delegate = nil
        lblTitle.isHidden = true
        playImg.isHidden = true
    }
    
    // MARK: - Public interface
    
    func configureCell(platform: Platform?) {
        self.platform = platform
        
        setupPlatformCell()
    }
    
    func configureCell(cast: Cast?) {
        self.cast = cast
        
        setupCastCell()
    }
    
    func configureCell(video: Video?) {
        self.video = video
        
        setupVideoCell()
    }
    
    func setupPlatformCell() {
        guard let platform = platform else {
            return
        }
    }
    
    func setupCastCell() {
        guard let cast = cast else {
            return
        }
        
        // setup image
        if let imgPath = cast.image, let imageURL = ImageHelper.createImageURL(path: imgPath, size: .profile(size: .medium)) {
            coverImgView.imageFrom(url: imageURL)
        } else {
            // No image for this person :(
            if let gender = cast.gender, gender == .female {
                coverImgView.image = kEmptyStateUserFemale
            } else {
                coverImgView.image = kEmptyStateUserMale
            }
        }
        // round
        coverImgView.roundCornersForAspectFit(radius: coverImgView.frame.height / 2)
        
        // setup name
        lblTitle.isHidden = false
        lblTitle.text = cast.name
    }
    
    func setupVideoCell() {
        guard let video = video else {
            return
        }
        
        if let videoImgUrl = VideoHelper.getURLForPreview(for: video) {
            coverImgView.imageFrom(url: videoImgUrl)
        }
        
        lblTitle.isHidden = false
        lblTitle.text = video.name
    }
    // MARK: - Auxiliar functions
    
    private func setupLayout() {
        lblTitle.font = .systemFont(ofSize: 14.0, weight: .light)
        lblTitle.textColor = .white
        lblTitle.numberOfLines = 0
    }
}
