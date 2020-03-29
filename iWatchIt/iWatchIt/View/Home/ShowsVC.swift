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
        setupNav(title: "Shows")
        loadData(mediaType: .show)
    }
}
