//
//  BannerAdCVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/08/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class BannerAdCVC: UICollectionViewCell, Reusable {
    var banner: UIView?
    
    func configureWithBanner(banner: UIView) {
        
        guard self.banner == nil else {return}
        
        self.banner = banner
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        
        banner.center = contentView.center
        contentView.addSubview(banner)
    }
}
