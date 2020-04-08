//
//  DetailVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DetailVC: BaseVC, DetailPresenterToViewProtocol {
    // MARK: - Properties
    var sections: [String] = []
    var contentId: Int?
    var type: MediaType?
    
    @IBOutlet weak var mainCV: UICollectionView! {
        didSet {
            mainCV.backgroundColor = .clear
            mainCV.delegate = self
            mainCV.dataSource = self
            mainCV.allowsSelection = false
            
            mainCV.register(UINib(nibName: kDetailHeaderCVC, bundle: .main), forCellWithReuseIdentifier: kDetailHeaderCVC)
            mainCV.register(UINib(nibName: kDetailOverviewCVC, bundle: .main), forCellWithReuseIdentifier: kDetailOverviewCVC)
            mainCV.register(UINib(nibName: kHorizontalCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kHorizontalCarouselCVC)
            
            mainCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            mainCV.bounces = false
            mainCV.alwaysBounceVertical = true
            mainCV.backgroundColor = .clear
        }
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        loadDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Auxiliar functions
    
    func setupNav() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        if let presenter = getPresenter(), let id = presenter.detail?.id {
            
            let isInWatchlist = WatchlistManager.shared.isInWatchlist(id: id)
            
            let rightBtn = isInWatchlist ? UIBarButtonItem.init(type: .watchlistAdded, target: self, action: #selector(share)) : UIBarButtonItem.init(type: .watchlistAdd, target: self, action: #selector(share))
            
            navigationItem.rightBarButtonItems = [.init(type: .share, target: self, action: #selector(share)), rightBtn]
            navigationItem.title = presenter.detail?.title ?? presenter.detail?.name
        }
    }
    
    func loadDetail() {
        guard let presenter = getPresenter() else {
            return
        }
        presenter.startFetchingDetail(type: type, id: contentId)
    }
    
    func reloadData() {
        mainCV.reloadData()
    }
    
    func reloadSection(section: String) {
        if let index = sections.firstIndex(of: section) {
            mainCV.reloadItems(at: [.init(item: 0, section: index)])
        }
    }
    
    func setupSections() {
        guard let presenter = getPresenter(), let detail = presenter.detail else {
            return
        }
        
        sections.append(kSectionDetailHeader)
        
        if let overview = detail.overview, !overview.isEmpty {
            sections.append(kSectionDetailOverview)
        }
        
        sections.append(kSectionDetailPlatforms)
        
        if let cast = detail.credits?.cast, !cast.isEmpty {
            sections.append(kSectionDetailCast)
        }
        
        if let videos = detail.videos?.results, !videos.isEmpty {
            sections.append(kSectionDetailVideos)
        }
    }
    
    func loadBackground() {
        let imageView = UIImageView(frame: view.frame)
        if let imagePth = getPresenter()?.detail?.image, let imgURL = ImageHelper.createImageURL(path: imagePth, size: .poster(size: .xbig)) {
            imageView.imageFrom(url: imgURL, with: nil)
        } else {
            imageView.image = kEmptyStateMedia
        }
        imageView.contentMode = .scaleToFill
        view.insertSubview(imageView, at: 0)
    }
    
    func getPresenter() -> DetailViewToPresenterProtocol? {
        guard let presenter = self.presenter as? DetailViewToPresenterProtocol else {
            showError(message: "app_error_generic".localized)
            return nil
        }
        return presenter
    }
    
    // MARK: - Presenter
    
    func onDetailFetched() {
        setupSections() 
        reloadData()
        setupNav()
        loadBackground()
    }
    
    func onPlatformsFetched() {
        reloadSection(section: kSectionDetailPlatforms)
    }
    
    // MARK: - Actions
    
    @objc func share() {
        // set up activity view controller
        let text = "See this film!!" // FIXME: DYNAMIC LINKSSS
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func cellForHeader(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kDetailHeaderCVC, for: indexPath) as? DetailHeaderCVC else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(with: getPresenter()?.detail?.image,
                           and: getPresenter()?.detail?.createDescriptionForHeader())
        
        return cell
    }
    
    func cellForOverview(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kDetailOverviewCVC, for: indexPath) as? DetailOverviewCVC else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: getPresenter()?.detail?.voteAverage, and: "detail_overview_section".localized, and: getPresenter()?.detail?.overview)
//        cell.addGradient(startColor: .black, endColor: UIColor.black.withAlphaComponent(0.8))
        return cell
    }
    
    func cellForPlatform(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kHorizontalCarouselCVC, for: indexPath) as? HorizontalCarouselCVC else {
            return UICollectionViewCell()
        }
        cell.configureCell(platformResponse: getPresenter()?.platforms, title: "detail_platforms_section".localized)
        cell.delegate = self
        return cell
    }
    
    func cellForCast(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kHorizontalCarouselCVC, for: indexPath) as? HorizontalCarouselCVC else {
            return UICollectionViewCell()
        }
        cell.configureCell(castResponse: getPresenter()?.detail?.credits?.cast, title: "detail_cast_section".localized)
        cell.delegate = self
        return cell
    }
    
    func cellForVideos(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kHorizontalCarouselCVC, for: indexPath) as? HorizontalCarouselCVC else {
            return UICollectionViewCell()
        }
        cell.configureCell(videoResponse: getPresenter()?.detail?.videos?.results, title: "detail_videos_section".localized)
        cell.delegate = self
        return cell
    }
    
    func heightForOverview() -> CGFloat {
        if let overview = getPresenter()?.detail?.overview {
            let overviewExpectedHeight = overview.height(withConstrainedWidth: view.frame.width - 20, font: .systemFont(ofSize: 14.0, weight: .light))
            let totalHeight = overviewExpectedHeight + 60.0 // items offset
            return totalHeight
        }
        return 0.0
    }
}

// MARK: - UICollectionView

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case kSectionDetailHeader:
            return cellForHeader(indexPath: indexPath)
        case kSectionDetailOverview:
            return cellForOverview(indexPath: indexPath)
        case kSectionDetailPlatforms:
            return cellForPlatform(indexPath: indexPath)
        case kSectionDetailCast:
            return cellForCast(indexPath: indexPath)
        case kSectionDetailVideos:
            return cellForVideos(indexPath: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case kSectionDetailHeader:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightDetailSectionsHeader)
        case kSectionDetailOverview:
            return CGSize(width: UIScreen.main.bounds.width, height: heightForOverview())
        case kSectionDetailPlatforms:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightDetailSectionsPlatforms)
        case kSectionDetailCast:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightDetailSectionsCast)
        case kSectionDetailVideos:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightDetailSectionsVideo)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension DetailVC: HorizontalCarouselCVCDelegate {
    func navigateTo(platform: Platform) {
        PlatformHelper.goToPlatform(platform: platform)
    }
    
    func navigateTo(cast: Cast) {
        
    }
    
    func navigateTo(video: Video) {
        
    }
}
