//
//  ShowsVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class ShowsVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav(title: "home_title_shows".localized, type: .show)
        loadData(mediaType: .show)
    }
}
