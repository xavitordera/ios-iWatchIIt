//
//  DetailVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit
import WebKit

class DetailVC: BaseVC, DetailPresenterToViewProtocol {
    // MARK: - Properties
    var sections: [String] = []
    var contentId: Int?
    var type: MediaType?
    var videoPlayer: WKWebView?
    var videoIndexPath: IndexPath?
    
    @IBOutlet weak var mainCV: UICollectionView! {
        didSet {
            mainCV.backgroundColor = .clear
            mainCV.delegate = self
            mainCV.dataSource = self
            mainCV.allowsSelection = false
            
            mainCV.register(UINib(nibName: kDetailHeaderCVC, bundle: .main), forCellWithReuseIdentifier: kDetailHeaderCVC)
            mainCV.register(UINib(nibName: kDetailOverviewCVC, bundle: .main), forCellWithReuseIdentifier: kDetailOverviewCVC)
            mainCV.register(UINib(nibName: kHorizontalCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kHorizontalCarouselCVC)
            mainCV.register(cellType: BannerAdCVC.self)
            
            mainCV.contentInset = .zero
            mainCV.bounces = true
            mainCV.alwaysBounceVertical = true
            mainCV.backgroundColor = .clear
        }
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        loadDetail()
        prepareVideoPlayer()
        addOservers()
        attachToAdManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        AdManager.shared.deattach()
    }
    
    // MARK: - Auxiliar functions
    
    func addOservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(hideLoadingVideoCell), name: UIWindow.didBecomeHiddenNotification, object: nil)
    }
    
    func attachToAdManager() {
        AdManager.shared.attach(self)
    }
    
    func setupNav() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        if let presenter = getPresenter(), let id = presenter.detail?.id {
            let isInWatchlist = WatchlistManager.shared.isInWatchlist(id: id, type: type!)
            
            let rightBtn = isInWatchlist ? UIBarButtonItem.init(type: .watchlistAdded, target: self, action: #selector(watchlist)) : UIBarButtonItem.init(type: .watchlistAdd, target: self, action: #selector(watchlist))
            
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
        
        sections.append(kSectionCopyright)
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
        
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 1)
        
    }
    
    func prepareVideoPlayer() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = false
        configuration.mediaTypesRequiringUserActionForPlayback = []
        videoPlayer = WKWebView(frame: .zero, configuration: configuration)
        videoPlayer?.navigationDelegate = self
        videoPlayer?.uiDelegate = self
        view.addSubview(videoPlayer!)
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
    
    func getPresenter() -> DetailViewToPresenterProtocol? {
        guard let presenter = self.presenter as? DetailViewToPresenterProtocol else {
            showError(message: "app_error_generic".localized)
            return nil
        }
        return presenter
    }
    
    // MARK: - Actions
    
    @objc func share() {
        // set up activity view controller
        var content:ShareContent!
        switch type {
        case .movie:
            content = ShareContent.movie(
                id: "\(getPresenter()?.detail?.id ?? 0)",
                title: getPresenter()?.detail?.title ?? "",
                description: getPresenter()?.detail?.overview,
                image: ImageHelper.createImageURL(path: getPresenter()?.detail?.image ?? "", size: .poster(size: .small))?.absoluteString)
            
            
        case .show:
            content = ShareContent.show(
                id: "\(getPresenter()?.detail?.id ?? 0)",
                title: getPresenter()?.detail?.title ?? "",
                description: getPresenter()?.detail?.overview,
                image: ImageHelper.createImageURL(path: getPresenter()?.detail?.image ?? "", size: .poster(size: .small))?.absoluteString)
        default:
            break
        }
        
        DynamicLinkFactory.shared.share(content: content) { url in
            
            if let url = url {
                let activityViewController = UIActivityViewController(activityItems: [String(format:"share_message".localized, self.getPresenter()?.detail?.title ?? self.getPresenter()?.detail?.name ?? ""), url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func watchlist() {
        guard let presenter = getPresenter() else {
            return
        }
        presenter.didTapWatchlist() ? showAlert(message: "detail_added_to_watchlist".localized) : showAlert(message: "detail_removed_from_watchlist".localized)
        setupNav()
    }
    
    // MARK: - Collection View Cells
    func cellsForHeader(_ indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            return cellForHeader(indexPath)
        case 1:
            return cellForAd(indexPath)
        default:
            fatalError()
        }
    }
    
    func cellForHeader(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kDetailHeaderCVC, for: indexPath) as? DetailHeaderCVC else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(with: getPresenter()?.detail?.image,
                           and: getPresenter()?.detail?.createDescriptionForHeader())
        
        return cell
    }
    
    func cellForAd(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCV.dequeueReusableCell(for: indexPath, cellType: BannerAdCVC.self)
        
        cell.configureWithBanner(banner: viewForBanner(size: CGSize(width: UIScreen.main.bounds.width, height: kHeightBannerAd)))
        
        return cell
    }
    
    func cellForOverview(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kDetailOverviewCVC, for: indexPath) as? DetailOverviewCVC else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(with: getPresenter()?.detail?.voteAverage, and: "detail_overview_section".localized, and: getPresenter()?.detail?.overview)
        return cell
    }
    
    func cellForPlatform(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kHorizontalCarouselCVC, for: indexPath) as? HorizontalCarouselCVC else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(platformResponse: getPresenter()?.platforms, title: "detail_platforms_section".localized)
        cell.delegate = self
        return cell
    }
    
    func cellForCast(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kHorizontalCarouselCVC, for: indexPath) as? HorizontalCarouselCVC else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(castResponse: getPresenter()?.detail?.credits?.cast, title: "detail_cast_section".localized)
        cell.delegate = self
        return cell
    }
    
    func cellForVideos(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCV.dequeueReusableCell(withReuseIdentifier: kHorizontalCarouselCVC, for: indexPath) as? HorizontalCarouselCVC else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(videoResponse: getPresenter()?.detail?.videos?.results, title: "detail_videos_section".localized)
        cell.delegate = self
        return cell
    }
    
    func cellForCopyright(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCV.dequeueReusableCell(for: indexPath, cellType: BannerAdCVC.self)
        
        cell.configureWithBanner(banner: UIImageView(image: kTMBDLogo))
        
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
    
    func sizeForHeaderCells(_ indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightDetailSectionsHeader)
        case 1:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightBannerAd)
        default:
            fatalError()
        }
    }
}

// MARK: - UICollectionView

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sections[section] == kSectionDetailHeader {
            return 2
        }
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case kSectionDetailHeader:
            return cellsForHeader(indexPath)
        case kSectionDetailOverview:
            return cellForOverview(indexPath)
        case kSectionDetailPlatforms:
            return cellForPlatform(indexPath)
        case kSectionDetailCast:
            return cellForCast(indexPath)
        case kSectionDetailVideos:
            return cellForVideos(indexPath)
        case kSectionCopyright:
            return cellForCopyright(indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case kSectionDetailHeader:
            return sizeForHeaderCells(indexPath)
        case kSectionDetailOverview:
            return CGSize(width: UIScreen.main.bounds.width, height: heightForOverview())
        case kSectionDetailPlatforms:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightDetailSectionsPlatforms)
        case kSectionDetailCast:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightDetailSectionsCast)
        case kSectionDetailVideos:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightDetailSectionsVideo)
        case kSectionCopyright:
            return CGSize(width: UIScreen.main.bounds.width, height: kHeightBannerAd)
        default:
            return .zero
        }
    }
}

extension DetailVC: HorizontalCarouselCVCDelegate {
    func navigateTo(platform: Platform) {
        if let presenter = getPresenter() {
            presenter.didTapOnPlatform(platform: platform)
        }
    }
    
    func navigateTo(cast: Cast) {
        if let presenter = getPresenter() {
            presenter.didTapOnCast(cast: cast, nav: navigationController)
        }
    }
    
    func navigateTo(video: Video, indexPath: IndexPath) {
        if let presenter = getPresenter(), let nav = navigationController {
            presenter.didTapOnVideo(video: video, nav: nav)
        }
        
        guard let urlStr = VideoHelper.getVideoURLForEmbed(for: video), let url = URL(string: urlStr), let videoPlayer = videoPlayer else  {
            return
        }
        
        videoIndexPath = indexPath
        
        var embedVideoHtml:String {
            return """
            <!DOCTYPE html>
            <html>
            <body>
            <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
            <div id="player"></div>
            
            <script>
            var tag = document.createElement('script');
            
            tag.src = "https://www.youtube.com/iframe_api";
            var firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
            
            var player;
            function onYouTubeIframeAPIReady() {
            player = new YT.Player('player', {
            height: '\(videoPlayer.frame.height)',
            width: '\(videoPlayer.frame.width)',
            videoId: '\(url.lastPathComponent)',
            events: {
            'onReady': onPlayerReady
            }
            });
            }
            
            function onPlayerReady(event) {
            event.target.playVideo();
            }
            </script>
            </body>
            </html>
            """
        }
        videoPlayer.loadHTMLString(embedVideoHtml, baseURL: nil)
        startLoadingVideoCell(at: indexPath)
    }
    
    func startLoadingVideoCell(at indexPath: IndexPath) {
        if let index = sections.firstIndex(of: kSectionDetailVideos), let cell = mainCV.cellForItem(at: .init(row: 0, section: index)) as? HorizontalCarouselCVC {
            if let videoCell = cell.carouselCV.cellForItem(at: indexPath) as? DetailCarouselTrailerCVC {
                videoCell.startLoading()
            }
        }
    }
    
    @objc func hideLoadingVideoCell(_ notification: Notification) {
        guard let indexPath = videoIndexPath else {return}
        videoIndexPath = nil
        if let index = sections.firstIndex(of: kSectionDetailVideos), let cell = mainCV.cellForItem(at: .init(row: 0, section: index)) as? HorizontalCarouselCVC {
            if let videoCell = cell.carouselCV.cellForItem(at: indexPath) as? DetailCarouselTrailerCVC {
                videoCell.hideLoading()
            }
        }
    }
}

extension DetailVC: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //        hideLoadingVideoCell()
        print("failed")
    }
    
}
