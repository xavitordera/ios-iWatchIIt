//
//  BannerTVC.swift
//  iWatchIt
//
//  Created by Xavier Tordera on 09/10/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class BannerAdTVC: UITableViewCell, Reusable {
    var banner: UIView?
    
    func configureWithBanner(banner: UIView) {
        
        guard self.banner == nil else {return}
        
        self.banner = banner
        
        banner.center = contentView.center
        contentView.addSubview(banner)
    }
}
