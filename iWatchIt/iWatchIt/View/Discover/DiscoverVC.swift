//
//  DiscoverVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

enum SegmentIndexes: Int {
    case shows = 0
    case movies = 1
}

class DiscoverVC: BaseVC {
    
    // MARK: - Properties
    var sections: [String] = []
    
    
    @IBOutlet weak var mainTV: UITableView! {
        didSet {
            mainTV.separatorStyle = .none
            mainTV.register(headerFooterViewType: DiscoverHeaderTVC.self)
            
            
        }
    }
    
    @IBOutlet weak var segMediaType: UISegmentedControl! {
        didSet {
            segMediaType.setTitle("discover_tv_shows_tab".localized, forSegmentAt: SegmentIndexes.shows.rawValue)
            segMediaType.setTitle("discover_movies_tab".localized, forSegmentAt: SegmentIndexes.movies.rawValue)
        }
    }
    
    var searchButton: UIButton?
    // MARK: - UIVienController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Auxiliar functions
    
    func setupNav() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "discover_title".localized
    }
    
    func setupSearchButton() {
        searchButton = UIButton(frame: .init(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height - 160, width: 150, height: 40))
        searchButton?.backgroundColor = .darkGray
        searchButton?.setTitleColor(.black, for: .normal)
        searchButton?.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .regular)
        searchButton?.setTitle("discover_search".localized, for: .normal)
        searchButton?.setImage(kTabDiscoverImg, for: .normal)
        searchButton?.layer.cornerRadius = 14
        searchButton?.layer.borderWidth = 1
        searchButton?.layer.borderColor = UIColor.black.cgColor
        searchButton?.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        searchButton?.addTarget(self, action: #selector(searchTap), for: .touchUpInside)
        
        view.addSubview(searchButton!)
    }
    
    func setup() {
        setupNav()
        setupSearchButton()
    }
    
    // MARK: - Actions
    
    @objc func searchTap() {
        
    }
}

extension DiscoverVC: DiscoverPresenterToViewProtocol {
    func onKeywordsFetched(isEmpty: Bool) {
        if getPresenter(type: DiscoverViewToPresenterProtocol.self) != nil {
            
        }
    }
    
    func onGenresFiltered(isEmpty: Bool) {
        
    }
    
    func onPeopleFetched(isEmpty: Bool) {
        
    }
}

extension DiscoverVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        swi
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
