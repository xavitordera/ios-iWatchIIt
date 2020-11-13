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
    func navigateTo(video: Video, indexPath: IndexPath)
    func navigateTo(content: Content)
}

class HorizontalCarouselCVC: UICollectionViewCell, NibReusable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var carouselCV: UICollectionView!
    @IBOutlet weak var emptyLbl: UILabel!
    
    var platformResponse: [Platform]?
    var castResponse: [Cast]?
    var videoResponse: [Video]?
    var contentResponse: [Content]?
    
    // Variables
    weak var delegate: HorizontalCarouselCVCDelegate?
    
    // MARK: - UIView
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        platformResponse = nil
        videoResponse = nil
        castResponse = nil
        
        titleLbl.text = nil
        delegate = nil
        emptyLbl.text = nil
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
        carouselCV.register(UINib(nibName: kDetailCarouselCastCVC, bundle: .main), forCellWithReuseIdentifier: kDetailCarouselCastCVC)
        carouselCV.register(UINib(nibName: kDetailCarouselPlatformCVC, bundle: .main), forCellWithReuseIdentifier: kDetailCarouselPlatformCVC)
        carouselCV.register(UINib(nibName: kDetailCarouselTrailerCVC, bundle: .main), forCellWithReuseIdentifier: kDetailCarouselTrailerCVC)
        carouselCV.register(UINib(nibName: kInfiniteCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kInfiniteCarouselCVC)
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
        
        // Background
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        
        emptyLbl.font = .systemFont(ofSize: 14.0, weight: .light)
        emptyLbl.textColor = kColorEmptyStatePlatforms
        emptyLbl.textAlignment = .center
    }
    
    func loadEmptyState(with text: String) {
        emptyLbl.text = text
    }
    
    // MARK: - Public Interface
    
    func configureCell(platformResponse: [Platform]?, title: String?) {
        self.platformResponse = platformResponse
        self.titleLbl.text = title
        if let platformResponse = platformResponse, !platformResponse.isEmpty {
            setupLayout()
        } else {
            loadEmptyState(with: "detail_empty_platforms".localized)
        }
    }
    
    func configureCell(castResponse: [Cast]?, title: String?) {
        self.castResponse = castResponse
        self.titleLbl.text = title
        setupLayout()
    }
    
    func configureCell(videoResponse: [Video]?, title: String?) {
        self.videoResponse = videoResponse
        self.titleLbl.text = title
        setupLayout()
    }
    
    func configureCell(contentResponse: [Content]?, title: String?) {
        self.contentResponse = contentResponse
        self.titleLbl.text = title
        setupLayout()
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
        }
        else if contentResponse != nil && !(contentResponse?.isEmpty ?? true) {
            return contentResponse?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if platformResponse != nil {
            if platformResponse!.count >= indexPath.row {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDetailCarouselPlatformCVC, for: indexPath) as? DetailCarouselPlatformCVC {
                    cell.configureCell(platform: self.platformResponse?[indexPath.row])
                    return cell
                }
            }
        }
            
        else if castResponse != nil {
            if castResponse!.count >= indexPath.row {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDetailCarouselCastCVC, for: indexPath) as? DetailCarouselCastCVC {
                    cell.configureCell(cast: self.castResponse?[indexPath.row])
                    return cell
                }
            }
        }
        
        else if videoResponse != nil {
            if videoResponse!.count >= indexPath.row {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDetailCarouselTrailerCVC, for: indexPath) as? DetailCarouselTrailerCVC {
                cell.configureCell(video: self.videoResponse?[indexPath.row])
                return cell
                }
            }
        }
        
        else if contentResponse != nil {
            if contentResponse!.count >= indexPath.row {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kInfiniteCarouselCVC, for: indexPath) as? InfiniteCarouselCVC {
                    cell.configureCell(contentResponse: self.contentResponse?[indexPath.row])
                    cell.delegate = self
                    return cell
                }
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _ = castResponse {
            return .init(width: 85, height: 164)
        } else if let _ = platformResponse {
            return .init(width: 100, height: 100)
        } else if let _ = videoResponse {
            return .init(width: 200, height: 250)
        } else if let _ = contentResponse {
            return .init(width: kHeightDetailSectionsSimilar * 9/16, height: kHeightDetailSectionsSimilar)
        } else {
            return UICollectionViewFlowLayout.automaticSize
        }
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
            delegate?.navigateTo(video: videos[indexPath.row], indexPath: indexPath)
        } else if let content = contentResponse {
            delegate?.navigateTo(content: content[indexPath.row])
        }
    }
}

extension HorizontalCarouselCVC: InfiniteCarouselCVCDelegate {
    func didTapCell(id: Int) {
        guard let content = contentResponse?.first(where: {content in
            content.id == id
        })
        else { return }
        delegate?.navigateTo(content: content)
    }
}
