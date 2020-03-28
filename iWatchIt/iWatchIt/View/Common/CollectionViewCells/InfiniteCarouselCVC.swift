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

class InfiniteCarouselCVC: UICollectionViewCell, NibReusable {

    // MARK: - Properties
    var contentResponse: HomeConten?
    var coverType: CoverType = .single
    
    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var miniCoverImg: UIImageView!
    @IBOutlet weak var miniCoverImg2: UIImageView!
    @IBOutlet weak var miniCoverImg3: UIImageView!
    @IBOutlet weak var miniCoverImg4: UIImageView!
    
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
        coverType = .single
        
        coverImgView.image = nil
        titleLbl.text = ""
        subtitleLbl.text = ""
        miniCoverImg.image = nil
        miniCoverImg2.image = nil
        miniCoverImg3.image = nil
        miniCoverImg4.image = nil
    }
    
    // MARK: - Public interface
    
    func configureCell(contentResponse: HomeContent?) {
        self.contentResponse = contentResponse
        
        setupCell()
    }
    
    func configureCell(contn: Media?, indexPath: IndexPath) {
        self.contentResponse = mediaResponse.flatMap { HomeContent() }
        
        setupCell(indexPath: indexPath)
    }
    
    private func setupCellUser() {
        titleLbl.text = contentResponse?.user?.userName

        subtitleLbl.text = String(Double(contentResponse?.user?.countFollowers ?? 0).kmFormatted) + " " + "infinite_carousel.followers".localized
        coverImgView.imageFrom(urlString: contentResponse?.user?.avatar ?? "")
        coverType = .artist
        setupCover()
    }
    
    private func setupCellArtist() {
        titleLbl.text = contentResponse?.artist?.artistName
        subtitleLbl.text = String(Double(contentResponse?.artist?.countFollowers ?? 0).kmFormatted) + " " + "infinite_carousel.followers".localized
        coverImgView.imageFrom(urlString: contentResponse?.artist?.avatar ?? "")
        coverType = .artist
        setupCover()
    }
    
    private func setupCellCollection() {
        titleLbl.text = contentResponse?.collection?.title
        subtitleLbl.text = contentResponse?.collection?.artist?.artistName ?? contentResponse?.collection?.artistName
        coverImgView.imageFrom(urlString: contentResponse?.collection?.image ?? "")
        coverType = .single
        setupCover()
    }
    
    private func setupCellPlaylist(indexPath: IndexPath?) {
        titleLbl.text = contentResponse?.playlist?.title
        subtitleLbl.text = contentResponse?.playlist?.userName
        
        if let urlString = contentResponse?.playlist?.image1, let url = URL(string: urlString) {
            let resource = ImageResource(downloadURL: url, cacheKey: "\(url)-\(String(describing: indexPath?.row))-1")
            
            coverImgView.kf.indicatorType = .activity
            coverImgView.kf.setImage(
                with: resource,
                options: [
                    .cacheOriginalImage
                ]
            ) { [weak self] result in
                self?.miniCoverImg.image = self?.coverImgView.image
            }
        }
        
        if let urlString = contentResponse?.playlist?.image2, let url = URL(string: urlString) {
            let resource = ImageResource(downloadURL: url, cacheKey: "\(url)-\(String(describing: indexPath?.row))-1")
            
            miniCoverImg2.kf.indicatorType = .activity
            miniCoverImg2.kf.setImage(
                with: resource,
                options: [
                    .cacheOriginalImage
                ]
            )
        }
        
        if let urlString = contentResponse?.playlist?.image3, let url = URL(string: urlString) {
            let resource = ImageResource(downloadURL: url, cacheKey: "\(url)-\(String(describing: indexPath?.row))-1")
            
            miniCoverImg3.kf.indicatorType = .activity
            miniCoverImg3.kf.setImage(
                with: resource,
                options: [
                    .cacheOriginalImage
                ]
            )
        }
        
        if let urlString = contentResponse?.playlist?.image4, let url = URL(string: urlString) {
            let resource = ImageResource(downloadURL: url, cacheKey: "\(url)-\(String(describing: indexPath?.row))-1")
            
            miniCoverImg4.kf.indicatorType = .activity
            miniCoverImg4.kf.setImage(
                with: resource,
                options: [
                    .cacheOriginalImage
                ]
            )
        }
        
        coverType = .multiple
        setupCover()
    }
    
    private func setupCellMedia(indexPath: IndexPath?) {
        titleLbl.text = contentResponse?.media?.title
        
        if let artistName = contentResponse?.media?.artistName {
            subtitleLbl.text = artistName
        }
        
        coverImgView.imageFrom(urlString: contentResponse?.media?.image ?? "")
        coverType = .single
        setupCover()
    }
    
    private func setupCell(indexPath: IndexPath? = nil) {
        coverImgView.image = kEmptyStateMedia
        miniCoverImg.image = kEmptyStateMedia
        miniCoverImg2.image = kEmptyStateMedia
        miniCoverImg3.image = kEmptyStateMedia
        miniCoverImg4.image = kEmptyStateMedia
        
        if contentResponse?.artist != nil {
            setupCellArtist()
        }
        
        if contentResponse?.collection != nil {
            setupCellCollection()
        }
        
        if contentResponse?.playlist != nil {
            setupCellPlaylist(indexPath: indexPath)
        }
        
        if contentResponse?.user != nil {
            setupCellUser()
        }
        
        if contentResponse?.media != nil {
            setupCellMedia(indexPath: indexPath)
        }
    }
    
    // MARK: - Auxiliar functions
    
    private func setupLayout() {
        // ImageView
        setupCover()
        
        // Title
        titleLbl.font = kFontSFProDisplayRegular
        titleLbl.textColor = kColorWhite
        titleLbl.textAlignment = .center
        
        // Subtitle
        subtitleLbl.font = kFontSFProDisplayRegular14
        subtitleLbl.textColor = kColorWhite
        subtitleLbl.textAlignment = .center
        subtitleLbl.alpha = 0.5
    }
    
    private func setupCover() {
        switch coverType {
        case .single:
            coverImgView.isHidden = false
            miniCoverImg.isHidden = true
            miniCoverImg2.isHidden = true
            miniCoverImg3.isHidden = true
            miniCoverImg4.isHidden = true
            coverImgView.layer.cornerRadius = 8
            coverImgView.contentMode = .scaleAspectFill
        case .multiple:
            coverImgView.isHidden = true
            miniCoverImg.isHidden = false
            miniCoverImg2.isHidden = false
            miniCoverImg3.isHidden = false
            miniCoverImg4.isHidden = false
            miniCoverImg.layer.cornerRadius = 5
            miniCoverImg2.layer.cornerRadius = 5
            miniCoverImg3.layer.cornerRadius = 5
            miniCoverImg4.layer.cornerRadius = 5
            miniCoverImg.contentMode = .scaleAspectFill
            miniCoverImg2.contentMode = .scaleAspectFill
            miniCoverImg3.contentMode = .scaleAspectFill
            miniCoverImg4.contentMode = .scaleAspectFill
        case .artist:
            coverImgView.isHidden = false
            miniCoverImg.isHidden = true
            miniCoverImg2.isHidden = true
            miniCoverImg3.isHidden = true
            miniCoverImg4.isHidden = true
            coverImgView.layer.cornerRadius = coverImgView.frame.width / 2
            coverImgView.contentMode = .scaleAspectFill
        }
    }
}

