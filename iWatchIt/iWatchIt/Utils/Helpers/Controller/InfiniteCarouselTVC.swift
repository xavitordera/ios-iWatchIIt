//
//  InfiniteCarouselTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.

import UIKit

protocol InfiniteCarouselTVCDelegate {
    func didTapSeeMore(section: HomeSectionType)
    func didTapContentCell(id: Int)
}

class InfiniteCarouselTVC: UITableViewCell, NibReusable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, InfiniteCarouselCVCDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var carousel: UICollectionView!
    
    @IBOutlet weak var emptyLbl: UILabel!
    var homeContentResponse: HomeSection?
    var delegate: InfiniteCarouselTVCDelegate?
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Horizontal scrolling
        if let layout = carousel.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLbl.text = ""
        homeContentResponse = nil
        homeContentResponse = HomeSection()
        carousel.reloadData()
        delegate = nil
        emptyLbl.text = nil
    }
    
    // MARK: - Auxiliar functions
    
    private func setupLayout() {
        backgroundColor = UIColor.clear
        
        // Carousel
        carousel.register(UINib(nibName: kInfiniteCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kInfiniteCarouselCVC)
        carousel.backgroundColor = UIColor.clear
        carousel.isPagingEnabled = false
        carousel.delegate = self
        carousel.dataSource = self
        carousel.clipsToBounds = false
        carousel.showsHorizontalScrollIndicator = false
        carousel.decelerationRate = .normal
        
        titleLbl.textColor = .whiteOrBlack
        titleLbl.font = .boldSystemFont(ofSize: 26.0)
        
        emptyLbl.font = .systemFont(ofSize: 14.0, weight: .light)
        emptyLbl.textColor = kColorEmptyStateLabel
        emptyLbl.textAlignment = .center
    }
    
    func loadEmptyState(with text: String) {
        emptyLbl.isHidden = false
        emptyLbl.text = text
    }
    
    // MARK: - Public Interface
    
    func configureCell(homeContentResponse: HomeSection?, isHiddingSeeMore: Bool = false) {
        self.homeContentResponse = homeContentResponse
        self.titleLbl.text = homeContentResponse?.title
        // Update view
    
        if let resp = homeContentResponse, let content = resp.content, !content.isEmpty {
            carousel.reloadData()
        } else {
            guard let type = homeContentResponse?.type else {return}
            switch type {
            case .Watchlist:
                loadEmptyState(with: "home_empty_watchlist".localized)
            default:
                break
            }
        }
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (homeContentResponse?.content?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kInfiniteCarouselCVC, for: indexPath) as? InfiniteCarouselCVC {
            if let _ = homeContentResponse {
                if indexPath.row < homeContentResponse!.content!.count {
                    cell.configureCell(contentResponse: homeContentResponse?.content![indexPath.row])
                    cell.delegate = self
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 136,
                      height: 204)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func didTapCell(content: Content) {
        delegate?.didTapContentCell(id: content.id ?? 0)
    }
}
