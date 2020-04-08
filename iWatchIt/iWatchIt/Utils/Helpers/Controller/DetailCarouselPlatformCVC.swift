//
//  DetailCarouselCVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DetailCarouselPlatformCVC: UICollectionViewCell, NibReusable {
    
    // MARK: - Properties
    var platform: Platform?
    
    var delegate: InfiniteCarouselCVCDelegate?
    
    @IBOutlet weak var coverImgView: UIImageView!
    
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
        
        coverImgView.image = nil
        delegate = nil
    }
    
    // MARK: - Public interface
    
    func configureCell(platform: Platform?) {
        self.platform = platform
        
        setupPlatformCell()
    }
    func setupPlatformCell() {
        guard let platform = platform else {
            return
        }
        if let site = platform.displayName, let image = PlatformHelper.getImageForSite(site: site)  {
            coverImgView.image = image
        } else {
            coverImgView.image = kEmptyStateMedia
        }
    }
    // MARK: - Auxiliar functions
    
    private func setupLayout() {
        coverImgView.contentMode = .scaleAspectFit
    }
}
