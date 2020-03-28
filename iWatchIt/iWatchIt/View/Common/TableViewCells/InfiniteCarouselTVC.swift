//
//  InfiniteCarouselTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.

import UIKit

protocol InfiniteCarouselTVCDelegate {
    func didTapSeeMore()
}

class InfiniteCarouselTVC: UITableViewCell, NibReusable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var moreLbl: UILabel!
    @IBOutlet weak var indicatorImageView: UIImageView!
    @IBOutlet weak var carousel: UICollectionView!
    
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
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLbl.text = ""
        homeContentResponse = nil
        moreLbl.isHidden = false
        homeContentResponse = HomeSection()
        carousel.reloadData()
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
        
        indicatorImageView.tintColor = .darkGray
    }
    
    @IBAction func pushMoreAction(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didTapSeeMore()
        }
    }
    
    // MARK: - Public Interface
    
    func configureCell(homeContentResponse: HomeSection?, isHiddingSeeMore: Bool = false) {
        self.homeContentResponse = homeContentResponse
        self.indicatorImageView.isHidden = isHiddingSeeMore
        // Update view
        carousel.reloadData()
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
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 136,
                      height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
