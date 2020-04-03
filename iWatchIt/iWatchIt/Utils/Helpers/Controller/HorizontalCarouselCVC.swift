//
//  HorizontalCarouselCVC.swift
//  WindowSightAPP
//
//  Created by Albert Mayans on 07/06/2019.
//  Copyright © 2019 Slashmobility. All rights reserved.
//

import UIKit

protocol HorizontalCarouselCVCDelegate: class {
    func navigateTo(platform: Platform)
    func navigateTo(cast: Cast)
    func navigateTo(video: Video)
}

class HorizontalCarouselCVC: UICollectionViewCell, NibReusable, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Properties

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var carouselCV: UICollectionView!
    
    var platformResponse: [Platform]?
    var castResponse: [Cast]?
    var videoResponse: [Video]?
    
    // Variables
    var indexPath: IndexPath?
    weak var delegate: HorizontalCarouselCVCDelegate?
    
    // MARK: - UIView
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLbl.text = nil
        delegate = nil
        indexPath = nil
        carouselCV.contentOffset.x = 0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupLayout()
    }
    
    // MARK: - Auxiliar functions
    
    private func setupLayout() {
        // Title
        titleLbl.font = .boldSystemFont(ofSize: 22.0)
        titleLbl.textColor = .white
        titleLbl.textAlignment = .left
        
        // Carousel
        carouselCV.register(UINib(nibName: kDetailCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kDetailCarouselCVC)
        carouselCV.backgroundColor = UIColor.clear
        carouselCV.isPagingEnabled = false
        carouselCV.delegate = self
        carouselCV.dataSource = self
        carouselCV.clipsToBounds = false
        carouselCV.showsHorizontalScrollIndicator = false
        
        // Horizontal scrolling
        if let layout = carouselCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        // Update view
        carouselCV.reloadData()
    }
    
    // MARK: - Public Interface
    
    func configureCell(platformResponse: [Platform]?, title: String?, showSeeAll: Bool = false, indexPath: IndexPath? = nil) {
        self.platformResponse = platformResponse
        self.titleLbl.text = title
    }
    
    func configureCell(castResponse: [Cast]?, title: String?, showSeeAll: Bool = false, indexPath: IndexPath? = nil) {
        self.castResponse = castResponse
        self.titleLbl.text = title
        self.indexPath = indexPath
    }
    
    func configureCell(videoResponse: [Video]?, title: String?, showSeeAll: Bool = false, indexPath: IndexPath? = nil) {
        self.videoResponse = videoResponse
        self.titleLbl.text = title
        self.indexPath = indexPath
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if platformResponse != nil && !(platformResponse?.isEmpty ?? true) {
            return platformResponse?.count ?? 0
        }
        else if castResponse != nil && !(castResponse?.isEmpty ?? true) {
            return castResponse?.count ?? 0
        }
        else if videoResponse != nil && !(videoResponse?.isEmpty ?? true) {
            return videoResponse?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDetailCarouselCVC, for: indexPath) as? DetailCarouselCVC {
            if platformResponse != nil {
                if platformResponse!.count >= indexPath.row {
                    cell.configureCell(platform: self.platformResponse?[indexPath.row])
                }
            }
            else if castResponse != nil {
                if castResponse!.count >= indexPath.row {
                    cell.configureCell(cast: self.castResponse?[indexPath.row])
                }
            }
            else if videoResponse != nil {
                if videoResponse!.count >= indexPath.row {
                    cell.configureCell(video: self.videoResponse?[indexPath.row])
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UICollectionViewFlowLayout.automaticSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let platforms = platformResponse {
            delegate?.navigateTo(platform: platforms[indexPath.row])
        } else if let cast = castResponse {
            delegate?.navigateTo(cast: cast[indexPath.row])
        } else if let videos = videoResponse {
            delegate?.navigateTo(video: videos[indexPath.row])
        }
    }
}
