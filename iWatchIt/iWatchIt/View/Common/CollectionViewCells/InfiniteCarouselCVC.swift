//
//  InfiniteCarouselCVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
//

import UIKit
import Kingfisher

protocol InfiniteCarouselCVCDelegate {
    func didTapCell()
}

class InfiniteCarouselCVC: UICollectionViewCell, NibReusable {

    // MARK: - Properties
    var contentResponse: HomeContent?
    var delegate: InfiniteCarouselTVCDelegate?
    
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
        
        contentResponse = nil
        
        coverImgView.image = nil
    }
    
    // MARK: - Public interface
    
    func configureCell(contentResponse: HomeContent?) {
        self.contentResponse = contentResponse
        
        setupCell()
    }
    
    private func setupCell() {
        coverImgView.imageFrom(urlString: contentResponse?.image ?? "")
    }
    
    // MARK: - Auxiliar functions
    
    private func setupLayout() {
        // ImageView
        let tapGesture = UITapGestureRecognizer.init(target: coverImgView, action: #selector(tapCell))
        coverImgView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapCell() {
        if let delegate = self.delegate {
            delegate.didTapSeeMore()
        }
    }
}

