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
    func didTapCell(id: Int)
}

class InfiniteCarouselCVC: UICollectionViewCell, NibReusable {

    // MARK: - Properties
    var contentResponse: Content?
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
        
        contentResponse = nil
        
        coverImgView.image = nil
        delegate = nil
    }
    
    // MARK: - Public interface
    
    func configureCell(contentResponse: Content?) {
        self.contentResponse = contentResponse
        
        setupCell()
    }
    
    private func setupCell() {
        guard let imgPath = contentResponse?.image,
            let imgURL = ImageHelper.createImageURL(path: imgPath, size: kHomeSectionsInfiniteCarouselImageSize)
        else { return }
        coverImgView.contentMode = .scaleAspectFill
        coverImgView.imageFrom(url: imgURL)
    }
    
    // MARK: - Auxiliar functions
    
    private func setupLayout() {
        // ImageView
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapCell))
        coverImgView.addGestureRecognizer(tapGesture)
    }
    
   @objc func tapCell(sender: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.didTapCell(id: contentResponse!.id)
        }
    }
}

