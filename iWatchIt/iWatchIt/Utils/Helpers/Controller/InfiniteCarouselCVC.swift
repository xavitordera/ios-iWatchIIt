//
//  InfiniteCarouselCVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
//

import UIKit


protocol InfiniteCarouselCVCDelegate {
    func didTapCell(content: Content)
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
        layer.borderWidth = 0
        scoreBtn.isHidden = true
        lblTitle.isHidden = true
    }
    
    // MARK: - Public interface
    
    func configureCell(contentResponse: Content?) {
        self.contentResponse = contentResponse
        
        setupCell()
    }
    
    private func setupCell() {
        
        if let voteAverage = contentResponse?.voteAverage, voteAverage > 0.0 {
            let x = String(format: "%.1f", voteAverage)
            scoreBtn.setTitle(x, for: .normal)
            scoreBtn.isHidden = false
        } else {
            scoreBtn.isHidden = true
        }
        
        guard let imgPath = contentResponse?.image, !imgPath.isEmpty, 
            let imgURL = ImageHelper.createImageURL(path: imgPath, size: kHomeSectionsInfiniteCarouselImageSize)
        else {
            coverImgView.image = kEmptyStateMedia
            lblTitle.text = contentResponse?.title ?? contentResponse?.name
            lblTitle.isHidden = false
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
            return
        }
        lblTitle.isHidden = true
        coverImgView.contentMode = .scaleAspectFill
        coverImgView.imageFrom(url: imgURL)
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
        if
            let delegate = self.delegate,
            let content = contentResponse
        {
            delegate.didTapCell(content: content)
        }
    }
}

