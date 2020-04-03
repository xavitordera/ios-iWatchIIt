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
            
            mainCV.register(UINib(nibName: kInfiniteCarouselTVC, bundle: .main), forCellWithReuseIdentifier: kInfiniteCarouselTVC)
            
            mainCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            
            mainCV.bounces = true
            mainCV.alwaysBounceVertical = true
        }
    }
    

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetail()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Auxiliar functions

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
        reloadData()
    }

}

// MARK: - UICollectionView

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}

extension DetailVC: InfiniteCarouselTVCDelegate {
    func didTapSeeMore(section: HomeSectionType) {
        
    }
    
    func didTapContentCell(id: Int) {
        
    }
}
