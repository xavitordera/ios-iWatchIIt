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
            
            mainCV.register(UINib(nibName: kHorizontalCarouselCVC, bundle: .main), forCellWithReuseIdentifier: kHorizontalCarouselCVC)
            
            mainCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            
            mainCV.bounces = true
            mainCV.alwaysBounceVertical = true
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
    
    // MARK: - Auxiliar functions
    
    func setupNav() {
        if let presenter = getPresenter(), let id = presenter.detail?.id {
            
            let isInWatchlist = WatchlistManager.shared.isInWatchlist(id: id)
            
            let rightBtn = isInWatchlist ? UIBarButtonItem.init(type: .watchlistAdded, target: self, action: #selector(share)) : UIBarButtonItem.init(type: .watchlistAdd, target: self, action: #selector(share))
            
            navigationItem.rightBarButtonItems = [.init(type: .share, target: self, action: #selector(share)), rightBtn]
            self.navigationController?.navigationBar.prefersLargeTitles = false
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
        
    }
    
    func setupSections() {
        
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
    }
    
    // MARK: - Actions
    
    @objc func share() {
        // set up activity view controller
        let text = "See this film!!"
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionView

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHorizontalCarouselCVC, for: indexPath) as? HorizontalCarouselCVC else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
}

extension DetailVC: InfiniteCarouselTVCDelegate {
    func didTapSeeMore(section: HomeSectionType) {
        
    }
    
    func didTapContentCell(id: Int) {
        
    }
}
