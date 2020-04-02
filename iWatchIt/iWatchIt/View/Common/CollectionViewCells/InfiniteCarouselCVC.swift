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
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var scoreBtn: UIButton!
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
        else {
            coverImgView.image = kEmptyStateMedia
            lblTitle.text = contentResponse?.title
            lblTitle.isHidden = false
            return
        }
        lblTitle.isHidden = true
        coverImgView.contentMode = .scaleAspectFill
        coverImgView.imageFrom(url: imgURL)
        if let voteAverage = contentResponse?.voteAverage, voteAverage > 0.0 {
            let x = String(format: "%.1f", voteAverage)
            scoreBtn.titleLabel?.text = x
        } else {
            scoreBtn.isHidden = true
        }
    }
    
    // MARK: - Auxiliar functions
    
    private func setupLayout() {
        // ImageView
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapCell))
        coverImgView.addGestureRecognizer(tapGesture)
        lblTitle.font = .systemFont(ofSize: 14.0, weight: .light)
        lblTitle.textColor = .black
        lblTitle.numberOfLines = 0
        scoreBtn.layer.cornerRadius = scoreBtn.frame.size.width / 3.5
    }
    
   @objc func tapCell(sender: UITapGestureRecognizer) {
    if let delegate = self.delegate, let id = contentResponse?.id {
            delegate.didTapCell(id: id)
        }
    }
}

